
simple_boot.bin: simple_boot.asm
	nasm -f bin simple_boot.asm -o simple_boot.bin
