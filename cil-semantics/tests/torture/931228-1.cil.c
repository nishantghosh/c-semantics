/* Generated by CIL v. 1.3.7 */
/* print_CIL_Input is true */

extern void exit(int status ) ;
extern void abort(void) ;
int f(int x ) 
{ 

  {
  x &= 4096;
  x &= 4095;
  x ^= 8191;
  x &= 8184;
  return (x);
}
}
int main(void) 
{ int tmp ;

  {
  tmp = f(-1);
  if (tmp != 8184) {
    abort();
  }
  exit(0);
}
}