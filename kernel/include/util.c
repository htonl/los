#include "util.h"

void *memcpy(void* dst, void* src, size_t n)
{
    size_t i;

    for (i = 0; i < n; i++)
        ((unsigned char*)dst)[i] = ((unsigned char*)src)[i];
    return dst;
}

void *memset(void* s, unsigned int c, size_t n)
{
    size_t i;

    for (i = 0; i < n; i++)
        *((unsigned int*)s + i)= c;
    return s;
}

