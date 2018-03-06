
# Change this if your cross-compiler is somewhere else
CC = i386-elf-gcc
GDB = i386-elf-gdb
LD = i386-elf-ld
# -g: Use debugging symbols in gcc
CFLAGS = -g

os.bin: boot.bin kernel.bin
	cat $^ > $@

boot.bin: \
	./boot/boot.asm \
	./boot/disk.asm \
	./boot/gdt.asm \
	./boot/pm_print.asm \
	./boot/print.asm \
	./boot/print_hex.asm \
	./boot/switch_to_pm.asm
	nasm -f bin ./boot/boot.asm -o boot.bin

kernel.bin: kernel_entry.o kernel.o
	i386-elf-ld -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.o: ./kernel/kernel.c
	i386-elf-gcc -ffreestanding -c $^ -o $@

kernel_entry.o: ./boot/kernel_entry.asm
	nasm $^ -f elf -o $@

run: os.bin
	qemu-system-x86_64 -fda ./os.bin

clean:
	rm *.o
	rm *.bin

