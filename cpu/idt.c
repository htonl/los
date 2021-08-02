#include "idt.h"
#include "isr.h"
#include <util.h>
#include "types.h"

int set_idt_gate(u32 n, u32 handler) {
	idt[n].low_offset = low_16(handler);
	idt[n].sel = KERNEL_CS;
	idt[n].always0 = 0;
	idt[n].flags = 0x8E;
	idt[n].high_offset = high_16(handler);
}

void set_idt() {
	idt_register.base = (u32) &idt;
	idt_reg.limit = IDT_ENTRIES * sizeof(idt_gate_t) - 1;

	__asm__ __volatile__("lidtl (%0)" : : "r" (&idt_register));
}
