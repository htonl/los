all:
	nasm los.asm -f bin -o los.bin
clean:
	rm los.bin
