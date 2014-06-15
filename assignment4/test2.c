#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

#define funprot_active 1

void
printError(int error) 
{
    switch(error) {
        case -1:
            printf(1,"faild: not enough arguments\n");
            break;
        case -2:
            printf(1,"faild: password is too long\n");
            break;
        case -3:
            printf(1,"faild: file does not exist\n");
            break;
        case -4:
            printf(1,"faild: file is in use by others\n");
            break;
        case -5:
            printf(1,"faild: password already has been set\n");
            break;
        case -6:
            printf(1,"faild: incorrect password\n");
            break;
    }
}

void
sanityTest(char * path, char * password) 
{
  int fd, error;
  char c;

  if( (error = fprot(path, password)) < 0)
      printError(error);

  if(fork() == 0) {
    // child unlock file
    if( (error = funlock(path, password)) < 0)
        printError(error);

    if( (fd = open(path, O_CREATE | O_RDONLY)) < 0)
        printf(1,"child faild to open file\n");

    printf(1, "************* FILE **************\n");
    while(1) {
        int bytesRead = read(fd,&c,1);
        if(bytesRead <= 0)
            break;
        printf(2, "%c",c);
    }

  } else {
    wait();

    printf(1,"In parent - After wait()\n");

    if( (fd = open(path, O_RDONLY)) < 0)
        printf(1,"parent faild to open file\n");

    if(funprot_active)
        if( (error = funprot(path, password)) < 0){
            printf(1,"parent faild to unprotect the file\n");
            printError(error);
        }
  }
}

int
main(int argc, char *argv[]) 
{

  if(argc != 3) {
    printf(1,"not enough params\n");
    exit();
  }

  char path[100];
  char password[10];

  strcpy(path, argv[1]);
  strcpy(password, argv[2]);

  //Do not release file 
  //funprot_active = 0;
  sanityTest(path,password);

  exit();
}
