
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/param.h"

#define MAXN 1024

int main(int argc, char *argv[])
{
    if (argc < 2) {
        fprintf(2, "usage: xargs command\n");
        exit(1);
    }
    sleep(10);
    char buf[MAXN];
    read(0,buf,MAXN);
    
    char *xargv[MAXARG];
    int xargc = 0;
    for (int i = 1;i < argc; i++)
    {
        xargv[xargc++] = argv[i];
    }

    char *p = buf;
    for (int i = 0; i< MAXN; i++)
    {
        if (buf[i] == '\n')
        {
            int pid = fork();
            if (pid > 0)
            {
                p = &buf[i+1];
                wait(0);
            }
            else
            {
                buf[i] = 0 ;
                xargv[xargc++] = p;
                xargv[xargc++] = 0;
                exec(xargv[0], xargv);
                exit(0);
            }
        }
    }
    exit(0);
}
