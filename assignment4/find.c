#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "fcntl.h"

#define true 1
#define false 0

// predicated
char path[100];
char name[DIRSIZ];
char filename[100];

int n;
int size_postive = false;
int size_negative = false;
char c;

int name_active   = false;
int size_active   = false;
int type_active   = false;
int follow_active = false;

int mode;

char*
fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}

char*
fmtname2(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;
  
  /*// Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
   p++;*/
  p = path;
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}

char*
fileName(char *path)
{
    static char buf[DIRSIZ+1];
    char *p;

    // Find first character after last slash.
    for(p=path+strlen(path); p >= path && *p != '/'; p--)
        ;
    p++;

    // Return blank-padded name.
    if(strlen(p) >= DIRSIZ)
        return p;
    memmove(buf, p, strlen(p));
    memset(buf+strlen(p), '\0', 1); //set clean string in buf
    return buf;
}

void print_data(char * path, struct stat st)
{
    if (!strcmp(path,".") || !strcmp(path,".."))
        return;

    if (name_active && size_active && type_active) {
        if (!strcmp(filename,fileName(path)) && 
                (   (st.type == T_DIR && c == 'd') ||
                    (st.type == T_FILE && c == 'f') ||
                    (st.type == T_SYMLINK && c == 's') )   ) {
            if (size_postive) {
                if(st.size >= n)
                    printf(1, "%s %d %d %d\n", fmtname2(path), st.type, st.ino, st.size);
            }
            if (size_negative) {
                if(st.size <= n)
                    printf(1, "%s %d %d %d\n",fmtname2(path), st.type, st.ino, st.size);
            }
        }

    } else if (name_active && size_active && !type_active) {
        if (!strcmp(filename,fileName(path))) {
            if (size_postive) {
                if(st.size >= n)
                    printf(1, "%s %d %d %d\n", fmtname2(path), st.type, st.ino, st.size);
            }
            if (size_negative) {
                if(st.size <= n)
                    printf(1, "%s %d %d %d\n",fmtname2(path), st.type, st.ino, st.size);
            }
        }
    } else if (name_active && !size_active && type_active) {
        if (!strcmp(filename,fileName(path)) && 
                (   (st.type == T_DIR && c == 'd') ||
                    (st.type == T_FILE && c == 'f') ||
                    (st.type == T_SYMLINK && c == 's') )   ) {
            printf(1, "%s %d %d %d\n", fmtname2(path), st.type, st.ino, st.size);
        }
    } else if (name_active && !size_active && !type_active) {
        if (!strcmp(filename,fileName(path)))
            printf(1, "%s %d %d %d\n", fmtname2(path), st.type, st.ino, st.size);
    } else if (!name_active && size_active && !type_active) {
        if (size_postive) {
            if(st.size >= n)
                printf(1, "%s %d %d %d\n", fmtname2(path), st.type, st.ino, st.size);
        }
        if (size_negative) {
            if(st.size <= n)
                printf(1, "%s %d %d %d\n",fmtname2(path), st.type, st.ino, st.size);
        }
    } else if (!name_active && !size_active && type_active) {
        if ((st.type == T_DIR  && c == 'd') ||
                (st.type == T_FILE && c == 'f') ||
                (st.type == T_SYMLINK && c == 's'))
            printf(1, "%s %d %d %d\n", fmtname2(path), st.type, st.ino, st.size);
    } else if (!name_active && !size_active && !type_active) {
        printf(1, "%s %d %d %d\n", fmtname2(path), st.type, st.ino, st.size);
    }
}

void 
find(char *path)
{
  char buf[512], *p;
  char link_path[512];
  char link_path_prefix[512];
  int fd;
      //,fd_sym;
  struct dirent de;
  struct stat st;
//  struct stat st_sym;
  
  if((fd = open(path, mode)) < 0){
    printf(2, "find: cannot open %s\n", path);
    return;
  }
  
  if(fstat(fd, &st) < 0){
    printf(2, "find: cannot stat %s\n", path);
    close(fd);
    return;
  }
  
  switch(st.type){
  case T_SYMLINK:
      if (follow_active) {
          read(fd,link_path,sizeof(link_path));
          printf(1,"in link path = %s \n",link_path);
          if (!(link_path[0] == '.')) {
              link_path_prefix[0] = '.';
              link_path_prefix[1] = '/';
              link_path_prefix[2] = 0;
              strcat(link_path_prefix,link_path);
              print_data(link_path_prefix,st);
          } else {
              print_data(link_path,st);
          }
      } else {
          print_data(path,st);
      }
    break;

  case T_FILE:
          print_data(path,st);
    break;

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf(1, "find: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';

    print_data(path,st);

    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      if(de.inum == 0)
        continue;
      memmove(p, de.name, DIRSIZ);
      p[DIRSIZ] = 0;
  
      if(!strcmp(p,".") || !strcmp(p,"..")) {
       } else {
           find(buf);
       }
    }
    break;
  }
  close(fd);
}

void 
printHelp()
{
     printf(1,"\n>>>Find -/Help<<<\n");
     printf(1,"-The find utility recursively descends the directory tree for\n\
               -each path listed, if mathched printing results\n\n");

     printf(1,"-/Options\n");
     printf(1,"-follow\n");
     printf(1,"    Dereference symbolic links. If a symbolic link is\n \
                   encountered, apply tests to the target of the link.\n \
                   If a symbolic link points to a directory, then descend into \
                   it.\n ");
     printf(1,"-help\n");
     printf(1,"    Print a summary of the command-line usage of find and exit\n\n.");

     printf(1,"-/Predicates\n");
     printf(1,"-name filename\n");
     printf(1,"    All files named (exactly,no wildcard) filename.\n");
     printf(1,"-size (+/-)n\n");
     printf(1,"    File is of size n (exactly), +n (more than n), -n (less than n).\n");
     printf(1,"-type c\n");
     printf(1,"    File is of type c:\n");
     printf(1,"         d       directory\n");
     printf(1,"         f       regular file\n");
     printf(1,"         s       soft (symbolic) link\n");
}

int
main(int argc, char *argv[])
{
  int i;
  char arg[100];

  if(argc < 2){
      printf(1,"Error() - Not enough arguments..\n");
    exit();
  }
  strcpy(path,argv[1]);

  mode = O_NODEREFERENCE | O_RDONLY;
  
  // starting parsing after path
  for(i=2; i<argc; i+=2) {
      strcpy(arg,argv[i]);

            if(!strcmp(arg,"-name"))    {
                strcpy(filename,argv[i+1]);
                name_active = true;

     } else if(!strcmp(arg,"-size"))    {

                if (argv[i+1][0] == '+') {
                    size_postive = true;
                } else if (argv[i+1][0] == '-') {
                    size_negative = true;
                }
                    n = atoi(&argv[i+1][1]);
                    size_active = true;

     } else if(!strcmp(arg,"-type"))    {

                c = *argv[i+1];
                type_active = true;

     } else if(!strcmp(arg,"-follow"))  {
                follow_active = true;

     } else if(!strcmp(arg,"-help"))    {
                 printHelp();
                 exit();
     }
  }
  find(path);

  exit();
}
