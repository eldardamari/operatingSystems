#include "types.h"
#include "stat.h"
#include "param.h"
#include "uthread.h"
#include "user.h"

/*int
main( int argc,char* argv[])
{
    //task 2
    [>char *c = (char*)-1;<]
      char *c = (char*)4096;

      printf(1,"Task 2 \n");
      c[0] = 'a';

      exit();
}*/

/*
    //task3
    int i;
    char* ptr = (void*)main;

    printf(1,"test3  \n");

    for(i = 0 ; i < 30 ; i++) {
        printf(1,"%c ",ptr[i]);
    }
    printf(1,"\n");

    strcpy(ptr,"this is new txt.");

    for(i = 0 ; i < 30 ; i++) {
        printf(1,"%c ",ptr[i]);
    }
    printf(1,"\n");*/
void testFunction()
{
    printf(1, "***printFunc***\n");
}

int main (int argc, char** argv)
{  
    testFunction();
    printf(1, "writing to text section started\n");  
    *((int*)testFunction) = 99;
    printf(1, "writing to text section finished\n");

    if (!fork()) {
        testFunction();  
    } else {
        testFunction();  
    }
    wait();
    exit();  
}
