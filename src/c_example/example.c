#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>  
#include <threads.h>
  
thread_local int tls = 1;

void *test(void *id)
{
    sleep(1);
    printf("in thread tls: %d\n",tls);
    thrd_exit(EXIT_SUCCESS);
}
   
int main()
{
    thrd_t thread_id;
    printf("main tls before: %d\n",tls);
    thrd_create(&thread_id,(thrd_start_t)test,NULL);
    tls = 2;
    printf("main tls after: %d\n",tls);
    thrd_join(thread_id,NULL);

    return EXIT_SUCCESS;
}
