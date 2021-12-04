#Thread Local Storage & wasm-ld -- thread_local! and Emscripten 

I've been investigating what it might take to get Rust to compile a threaded
program against the `wasm32-unknown-emscripten` compiler target.  The simple example in `src/main.rs`:

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
`--target=wasm32-unknown-emscripten` fails with with an error from `wasm-ld`
complaining about `relocation R_WASM_MEMORY_ADDR_TLS_SLEB cannot be used against non-TLS symbol 'std::io::stdio::OUTPUT_CAPTURE::__getit::__KEY::h776cf75763f0fad1'`, and
`relocation R_WASM_MEMORY_ADDR_TLS_SLEB cannot be used against non-TLS symbol 'std::sys_common::thread_info::THREAD_INFO::__getit::STATE::haca3e53312905f45 (.0.0.llvm.16251061034901608940)'`

...as near as I can tell, `std::io::stdio::OUTPUT_CAPTURE` is [wrapped
in](https://github.com/rust-lang/rust/blob/master/library/std/src/io/stdio.rs)
`thread_local!()` (line 20) and `std::sys_common::thread_info::THREAD_INFO`
[likewise](https://github.com/rust-lang/rust/blob/master/library/std/src/sys_common/thread_info.rs)
(line 13). 

The error message is the same with emscripten 2.0.34 and 3.0.0.  In order to
get this far, I've used a nightly Rust build (rustc 1.59.0-nightly) to enable recompliation of `std`
with `target-feature=+atomics,+bulk-memory` (otherwise it fails to link due to
`std` not being compiled for threads).  The cargo invocation is:

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
but note that is *not* `R_WASM_MEMORY_ADDR_TLS_SLEB`.  I'm presuming that the
SLEB is [Signed Little Endian Base](https://en.wikipedia.org/wiki/LEB128).  

I'm not sure if this due to me missing an appropriate complier/linker flag
issue, or something on the rust side (maybe the `thread_local!` macro needs to
be specialized for emscripten?).  It looks like there are configurations for
wasm targets in `__thread_local_inner`:

https://github.com/rust-lang/rust/blob/master/library/std/src/thread/local.rs

...but they all appears to targeted with a `not(target_feature = "atomics")`, like in:

    #[cfg(all(target_family = "wasm", not(target_feature = "atomics")))]

Maybe there needs to be one for wasm and atomics?  Issue #84224 might be related:

    https://github.com/rust-lang/rust/issues/84224

I would appreciate any pointers to more information about this issue, or a more
appropriate forum for this question.  

Thanks!


