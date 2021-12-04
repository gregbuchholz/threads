#!/usr/bin/sh
emcc example.c -lpthread  -pthread -s PROXY_TO_PTHREAD -s ASYNCIFY

