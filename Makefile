
boot.bin: boot.asm print.asm print_hex.asm disk.asm gdt.asm
	nasm -f bin boot.asm -o boot.bin

run: boot.bin
	qemu-system-x86_64 ./boot.bin

clean:
	rm boot.bin
