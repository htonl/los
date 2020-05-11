# Automatically generate lists of sources using wildcards .
C_SOURCES = $(wildcard kernel/*.c kernel/drivers/*/*.c kernel/include/*.c)
HEADERS = $(wildcard kernel/*.h kernel/drivers/*/*.h kernel/include/*.h)
INC = kernel/include/
# TODO : Make sources dep on all header files .
# Convert the *.c filenames to *.o to give a list of object files to build
OBJ = ${C_SOURCES:.c=.o}
CFLAGS = -g -m32 -fno-pie -ffreestanding

CC = gcc
GDB = gdb

# This is the actual disk image that the computer loads
# which is the combination of our compiled bootsector and kernel
os-image : boot/bootsect.bin kernel.bin
	cat $^ > os-image

# This builds the binary of our kernel from two object files :
# - the kernel_entry , which jumps to main () in our kernel
# - the compiled C kernel
kernel.bin : boot/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.elf: boot/kernel_entry.o ${OBJ}
	ld -m elf_i386 -o $@ -Ttext 0x1000 $^

debug: os-image kernel.elf
	qemu-system-i386 -s -fda os-image &
	${GDB} -ex "target remote localhost:1234" -ex "symbol-file kernel.elf"

# Run bochs to simulate booting of our code .
run: os-image
	qemu-system-i386 -fda os-image

# Generic rule for compiling C code to an object file
# For simplicity , we C files depend on all header files .
%.o : %.c ${HEADERS}
	${CC} ${CFLAGS} -I ${INC} -c $< -o $@

# Assemble the kernel_entry .
%.o : %.asm
	nasm $< -f elf -o $@

%.bin: %.asm
	nasm $< -f bin -o $@

clean :
	rm -fr *.bin *.dis *.o os-image
	rm -fr kernel/*.o boot/*.bin kernel/drivers/*/*.o boot/*.o kernel.elf
