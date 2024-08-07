#include "kernel/types.h"
#include "user/user.h"
#define PrimeNum 35


void primes(int read_fd)
{
  int previous, next;
  int fd[2];
  if (read(read_fd, &previous, sizeof(int)))
  {
    printf("prime %d\n", previous);
    pipe(fd);
    if (fork() == 0)
    {
      close(fd[0]);
      while (read(read_fd, &next, sizeof(int)))
      {
        if (next % previous != 0)
          write(fd[1], &next, sizeof(int));
      }
      close(fd[1]);
    }
    else
    {
      close(fd[1]);
      wait(0);
      primes(fd[0]);
      close(fd[0]);
    }  
  }  
}

int  main(int argc, char *argv[])
{
  int fd[2];
  pipe(fd);  

  if (fork() == 0) 
  {
    close(fd[0]);
    for (int i = 2; i < PrimeNum + 1; i++)
    {
      write(fd[1], &i, sizeof(int));
    }
    close(fd[1]);
  }
  else  
  {
    close(fd[1]);
    wait(0);
    primes(fd[0]);
    close(fd[0]);
  }
  exit(0);
}

