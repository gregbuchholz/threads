#!/usr/bin/sh
cargo build --target=wasm32-unknown-emscripten --release -Z build-std=panic_abort,std
