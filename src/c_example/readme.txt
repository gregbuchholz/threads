When working with Emscripten, compile with:

emcc example.c -lpthread  -pthread -s PROXY_TO_PTHREAD -s ASYNCIFY

...which is also in the file "compile_command.sh" and then run with either:

emrun index-asmjs.html

or

node --experimental-wasm-threads --experimental-wasm-bulk-memory a.out.js

You can also compile with gcc:

gcc example.c -lpthread

...and then run "./a.out" or "./a.exe"

