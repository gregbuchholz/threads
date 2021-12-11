//compile with:
//  emcc example3.c -o example3_js -pthread -s PROXY_TO_PTHREAD -s ASYNCIFY
//run:
//  node --experimental-wasm-threads --experimental-wasm-bulk-memory example3_js
//example output:
//  foo_atomic: 20000000, bar_non: 15482599

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>  
#include <threads.h>
#include <stdatomic.h>

#define ITER_LIM 10000000

atomic_int foo_atomic = 0;
int bar_non = 0;

void *test(void *id)
{
    for(int i = 0; i<ITER_LIM; ++i)
    {
        ++foo_atomic;
        ++bar_non;
    }
    thrd_exit(EXIT_SUCCESS);
}
   
int main()
{
    thrd_t thread_id;
    thrd_create(&thread_id,(thrd_start_t)test,NULL);

    for(int i = 0; i<ITER_LIM; ++i)
    {
        ++foo_atomic;
        ++bar_non;
    }

    thrd_join(thread_id,NULL);

    printf("foo_atomic: %d, bar_non: %d\n",foo_atomic, bar_non);
    return EXIT_SUCCESS;
}
