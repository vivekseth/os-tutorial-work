
# Change this if your cross-compiler is somewhere else
CC = i386-elf-gcc
GDB = i386-elf-gdb
LD = i386-elf-ld
EMU = qemu-system-i386

# -g: Use debugging symbols in gcc
CFLAGS = -g -I./ -masm=intel

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
	nasm ./boot/boot.asm -f bin -o boot.bin

kernel.bin: kernel_entry.o kernel.o ports.o
	${LD} -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.o: ./kernel/kernel.c
	${CC} ${CFLAGS} -ffreestanding -c $^ -o $@

ports.o: ./drivers/ports.c
	${CC} ${CFLAGS} -ffreestanding -c $^ -o $@

kernel_entry.o: ./boot/kernel_entry.asm
	nasm $^ -f elf -o $@

kernel.elf: kernel_entry.o kernel.o ports.o
	${LD} -o $@ -Ttext 0x1000 $^

run: os.bin
	${EMU} -fda ./os.bin

debug: os.bin kernel.elf
	${EMU} -s -fda ./os.bin \
	& ${GDB} -ex "symbol-file kernel.elf" -ex "target remote localhost:1234" -ex "b return_true"

clean:
	rm -f *.o
	rm -f *.bin
	rm -f *.elf


