#include "fsl-header.h"
unsigned int a[0x1000];
extern const unsigned long v;

main ()
{
  f (v);
  f (v);
  exit (0);
}

void f (a)
     unsigned long a;
{
  if (a != 0xdeadbeefL)
    abort();
}

const unsigned long v = 0xdeadbeefL;