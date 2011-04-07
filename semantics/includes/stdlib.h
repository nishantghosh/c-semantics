// stdlib.h
#define EXIT_FAILURE 1
#define RAND_MAX 2147483647
#define NULL ((void *)0)
typedef unsigned long int size_t; // this needs to correspond to cfg:sizeut
typedef struct {int quot; int rem;} div_t;
typedef struct {long int quot; long int rem;} ldiv_t;

void *malloc(size_t size);
void free(void *pointer);
void *calloc(size_t nelem, size_t elsize);
void exit(int status);
void debug(int i);
void srand (unsigned int seed);
int rand (void);
void abort( void );
int atoi ( const char * str );