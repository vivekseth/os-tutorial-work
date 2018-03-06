
os.bin: boot.bin kernel.bin
	cat boot.bin kernel.bin > os.bin

kernel.bin: kernel_entry.o kernel.o
	i386-elf-ld -o kernel.bin -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary

kernel.o: kernel.c
	i386-elf-gcc -ffreestanding -c kernel.c -o kernel.o

kernel_entry.o: kernel_entry.asm
	nasm kernel_entry.asm -f elf -o kernel_entry.o

boot.bin: boot.asm disk.asm gdt.asm kernel_entry.asm pm_print.asm print.asm print_hex.asm switch_to_pm.asm
	nasm -f bin boot.asm -o boot.bin

run: os.bin
	qemu-system-x86_64 -fda ./os.bin

clean:
	rm *.o
	rm *.bin

