#ifndef IDT_H
#define IDT_H

#include "types.h"

#define NUM_INTERRUPTS 256

struct idt_gate_descriptor {
	u16 low_offset;
	u16 segment;
	u8 unused;
	u8 flags;
	u16 high_offset;
} __attribute__((packed));

struct idt_register {
	u16 limit;
	u32 base;
} __attribute__((packed));

struct idt_gate_descriptor idt[NUM_INTERRUPTS];
struct idt_register idt_register;

void set_idt_gate(u32 n, u32 handler);
void set_idt();


#endif /* IDT_H */
