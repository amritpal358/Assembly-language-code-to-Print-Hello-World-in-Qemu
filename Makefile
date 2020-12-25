all:
	nasm boot2.asm -f bin -o boot2.bin
	qemu-system-x86_64 -fda boot2.bin
