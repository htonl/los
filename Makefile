all:
	make bootsect
	make kernel
	cat los.bin kernel.bin > os-image

bootsect:
	nasm los.asm -f bin -o los.bin

kernel:
	gcc -ffreestanding -c kernel.c -o kernel.o
	ld -o kernel.bin -Ttext 0x1000 kernel.o --oformat binary

run:
	qemu-system-x86_64 os-image

clean:
	rm *.bin
	rm *.o
	rm os-image
