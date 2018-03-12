
# Change this if your cross-compiler is somewhere else
CC = i386-elf-gcc
GDB = i386-elf-gdb
LD = i386-elf-ld
EMU = qemu-system-i386

# -g: Use debugging symbols in gcc
CFLAGS = -g -I./ -masm=intel

# Build Disk Image

os.bin: boot.bin kernel.bin
	# 8192 = 16 sectors (512 * 16)
	max_kernel_size=8192; \
	kernel_size="$$(($$(wc -c < kernel.bin)))"; \
	if (($$kernel_size < $$max_kernel_size)); \
	then \
		cat $^ > $@;\
		echo "Kernel meets size requirement!";\
	else \
		echo "KERNEL IS TOO LARGE";\
		echo "update load_kernel in boot.asm to accomodate new size";\
		echo "num_sectors = $kernel_entry / 512";\
	fi;

boot.bin: \
	./boot/boot.asm \
	./boot/disk.asm \
	./boot/gdt.asm \
	./boot/pm_print.asm \
	./boot/print.asm \
	./boot/print_hex.asm \
	./boot/switch_to_pm.asm
	nasm ./boot/boot.asm -f bin -o boot.bin

kernel.bin: kernel_entry.o kernel.o ports.o debug.o screen.o util.o
	${LD} -o $@ -Ttext 0x1000 $^ --oformat binary

kernel.elf: kernel_entry.o kernel.o ports.o debug.o screen.o util.o
	${LD} -o $@ -Ttext 0x1000 $^

debug: os.bin kernel.elf
	echo 'no-op'

# Compile Source

kernel.o: ./kernel/kernel.c
	${CC} ${CFLAGS} -ffreestanding -c $^ -o $@

debug.o: ./kernel/debug.c
	${CC} ${CFLAGS} -ffreestanding -c $^ -o $@

util.o: ./kernel/util.c
	${CC} ${CFLAGS} -ffreestanding -c $^ -o $@

screen.o: ./drivers/screen.c
	${CC} ${CFLAGS} -ffreestanding -c $^ -o $@

ports.o: ./drivers/ports.c
	${CC} ${CFLAGS} -ffreestanding -c $^ -o $@

kernel_entry.o: ./boot/kernel_entry.asm
	nasm $^ -f elf -o $@

# Run Targets

run: os.bin
	${EMU} -vga cirrus -fda ./os.bin

run-debug: debug
	${EMU} -s -fda ./os.bin \
	& ${GDB} -ex "symbol-file kernel.elf" -ex "target remote localhost:1234" -ex "b wait_for_debugger"

# Phony Targets

clean:
	rm -f *.o
	rm -f *.bin
	rm -f *.elf
