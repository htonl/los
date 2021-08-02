#ifndef TYPES_H
#define TYPES_H

typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned int u32;
typedef unsigned long long u64;
typedef char i8;
typedef unsigned short i16;
typedef int i32;
typedef long long i64;

#define low_16(addr) (u16)((address) & 0xFFFF)
#define high_16(addr) (u16)(((address) >> 16) & 0xFFFF)

#endif /* TYPES_H */
