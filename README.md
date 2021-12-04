This is a simple Rust program to see if we can't get threads working with the

`wasm32-unknown-emscripten` compiler target.  This is currently failing with an
error from `wasm-ld` complaining about:

    wasm-ld: error: /home/greg/rust-examples/threads/target/wasm32-unknown-emscripten/release/deps/libstd-c3ef1d33e4a2152f.rlib(std-c3ef1d33e4a2152f.std.ac802b8c-cgu.13.rcgu.o): relocation R_WASM_MEMORY_ADDR_TLS_SLEB cannot be used against non-TLS symbol `std::io::stdio::OUTPUT_CAPTURE::__getit::__KEY::h776cf75763f0fad1`

...this is the same error message with emscripten 2.0.34 and 3.0.0.  In order
to get this far, I've used a nightly Rust build to enable recompliation of
`std` with `target-feature=+atomics,+bulk-memory`.  The cargo invocation is:

    cargo build --target=wasm32-unknown-emscripten --release -Z build-std=panic_abort,std

...and there are additional `rustflags` in `.cargo/config`:

    [target.wasm32-unknown-emscripten]
    rustflags = [
        "-C", "target-feature=+atomics,+bulk-memory", 
        "-C", "link-args=src/gxx_personality_v0_stub.o -pthread -s PROXY_TO_PTHREAD"
    ]

...The `gxx_personality_v0_stub.cpp` file will also need to be compiled:

     em++ -c gxx_personality_v0_stub.cpp -pthread

...further information on `R_WASM_MEMORY_ADDR_SLEB` can be found at
[WebAssembly Object File
Linking](https://github.com/WebAssembly/tool-conventions/blob/main/Linking.md).

More information on the error message is in `error.txt`.  Not sure if this is
more of a complier/linker flag issue, something on the emscripten side, or on
the rust side of things.

