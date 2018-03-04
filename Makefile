
simple_boot.bin: simple_boot.asm print.asm
	nasm -f bin simple_boot.asm -o simple_boot.bin

run: simple_boot.bin
	qemu-system-x86_64 ./simple_boot.bin

clean:
	rm simple_boot.bin
