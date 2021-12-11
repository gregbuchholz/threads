#!/usr/bin/sh

#using newly built rustc
cargo +stage1 build --target=wasm32-unknown-emscripten --release -Z build-std=panic_abort,std

#using "stock" nightly rustc
#cargo build --target=wasm32-unknown-emscripten --release -Z build-std=panic_abort,std
