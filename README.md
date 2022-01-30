# Thread Local Storage, wasm-ld, thread_local!, and Emscripten 

This issue has been successfully resolved with the fix outlined in [emscripten issue #15891](https://github.com/emscripten-core/emscripten/issues/15891).
As of January 29th, 2022, install/compile the llvm in git with `emsdk install llvm-git-main-64bit` and friends.

First head over to `src/` and build:

    emcc -c gxx_personality_v0_stub.cpp -pthread

You can now compile with:

    cargo +nightly build --target=wasm32-unknown-emscripten --release -Z build-std=panic_abort,std

...and run the example in a browser with:

    emrun index-wasm.html

...or run with node like:

    node --experimental-wasm-threads --experimental-wasm-bulk-memory target/wasm32-unknown-emscripten/release/deps/threads.js

Happy multi-threading!
<details><summary>outdated problem summary</summary>

I've been investigating what it might take to get Rust to compile a threaded
program against the `wasm32-unknown-emscripten` compiler target.  The simple example in [src/main.rs](https://github.com/gregbuchholz/threads/blob/main/src/main.rs):

    use std::thread;

    fn xs() {
        for _ in 0 .. 10 {
            println!("X");
        }
    }

    fn main() {

        let t1 = thread::spawn(xs);
        t1.join().unwrap();
    }

...works when compiling for an x86_64 target, but for
`--target=wasm32-unknown-emscripten` fails to compile with with an error from `wasm-ld`
complaining about `relocation R_WASM_MEMORY_ADDR_TLS_SLEB cannot be used against non-TLS symbol 'std::io::stdio::OUTPUT_CAPTURE::__getit::__KEY::h776cf75763f0fad1'`, and
`relocation R_WASM_MEMORY_ADDR_TLS_SLEB cannot be used against non-TLS symbol 'std::sys_common::thread_info::THREAD_INFO::__getit::STATE::haca3e53312905f45'`.  (full error message in [error.txt](https://github.com/gregbuchholz/threads/blob/main/error.txt))

...as near as I can tell, `std::io::stdio::OUTPUT_CAPTURE` is [wrapped
in](https://github.com/rust-lang/rust/blob/master/library/std/src/io/stdio.rs)
`thread_local!()` (line 20) and `std::sys_common::thread_info::THREAD_INFO`
[likewise](https://github.com/rust-lang/rust/blob/master/library/std/src/sys_common/thread_info.rs)
(line 13). 

I'm presuming that the error is trying to tell me that something told the
linker to place these items in the thread local storage area, but that they
aren't properly marked as thread_local.  Which seems to be somewhat confirmed
by the wasm-ld source:

[https://github.com/llvm/llvm-project/blob/main/lld/wasm/Relocations.cpp](https://github.com/llvm/llvm-project/blob/main/lld/wasm/Relocations.cpp)

...with the `case` starting at line 113:

    case R_WASM_MEMORY_ADDR_TLS_SLEB:
    case R_WASM_MEMORY_ADDR_TLS_SLEB64:
      // In single-threaded builds TLS is lowered away and TLS data can be
      // merged with normal data and allowing TLS relocation in non-TLS
      // segments.
      if (config->sharedMemory) {
        if (!sym->isTLS()) {
          error(toString(file) + ": relocation " +
                relocTypeToString(reloc.Type) +
                " cannot be used against non-TLS symbol `" + toString(*sym) +
                "`");
        }

...that produces the above error message.  So why does `wasm-ld` think
`isTLS()` on those symbols is false? And maybe stranger, that `case` doesn't
appear to do anything useful in the event that isTLS() is true.  It only ever
produces error messages.  But thread local storage works out-of-the-box with
Emscripten and C, as shown by [this
program](https://github.com/gregbuchholz/threads/tree/main/src/c_example) over
in src/c_example/, and confirmed with Firefox and node.  Dumping the assembly
(emcc example.c -S -pthread) shows a ".section .tdata" in
[example.s](https://github.com/gregbuchholz/threads/blob/main/src/c_example/example.s).

The error message is the same with emscripten 2.0.34 and 3.0.0.  In order to
get this far, I've used a nightly Rust build (rustc 1.59.0-nightly (532d2b14c 2021-12-03)) 
to enable recompliation of `std` with `target-feature=+atomics,+bulk-memory`
(otherwise it fails to link due to `std` not being compiled for threads).  The
cargo invocation is:

    cargo build --target=wasm32-unknown-emscripten --release -Z build-std=panic_abort,std

...and there are additional `rustflags` needed in `.cargo/config`:

    [target.wasm32-unknown-emscripten]
    rustflags = [
        "-C", "target-feature=+atomics,+bulk-memory", 
        "-C", "link-args=src/gxx_personality_v0_stub.o -pthread -s PROXY_TO_PTHREAD"
    ]

...The `gxx_personality_v0_stub.cpp` file will also need to be compiled:

     em++ -c gxx_personality_v0_stub.cpp -pthread

...to overcome the issue described [here](https://stackoverflow.com/questions/67474533/error-in-compiling-rust-into-webassembly-using-emscripten-on-windows/69198170#69198170).  

I have been able to find a little additional information on
`R_WASM_MEMORY_ADDR_SLEB` over at [WebAssembly Object File
Linking](https://github.com/WebAssembly/tool-conventions/blob/main/Linking.md),
but note that is *not* `R_WASM_MEMORY_ADDR_TLS_SLEB`.  I'm assuming that the
SLEB is [Signed Little Endian Base](https://en.wikipedia.org/wiki/LEB128).  

I'm not sure if this due to missing an appropriate complier/linker flag
issue, or something on the rust side not quite right (maybe the `thread_local!`
macro needs to be specialized for emscripten?). Or if this is an issue on the
LLVM/wasm-ld side.  Or something with Emscripten.  Quite a few moving parts
here.  It looks like there are configurations for wasm targets in
`__thread_local_inner`:

[https://github.com/rust-lang/rust/blob/master/library/std/src/thread/local.rs](
https://github.com/rust-lang/rust/blob/master/library/std/src/thread/local.rs)

...it seems like the one starting on line 196 might be the "right" one for emscripten(?):

    // If the platform has support for `#[thread_local]`, use it.
    #[cfg(all(
        target_thread_local,
        not(all(target_family = "wasm", not(target_feature = "atomics"))),
    ))]

...at least with the belief that TLS works with Emscripten.

This issue might be related to [issue #84224](https://github.com/rust-lang/rust/issues/84224).

I'm not sure where to look to see how `#[thread_local]` is implemented in rustc.

I would appreciate any pointers to more information about this issue, or a more
appropriate forum for this question.  

Thanks!

</details>
