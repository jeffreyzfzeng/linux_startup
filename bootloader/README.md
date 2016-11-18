# bootloader

#Simple MBR img file, boot from floppy
	#How to compile assembly source code only:
	as test.S -o test.o
	ld -Ttext 0x7c00 --oformat=binary test.o -o test.bin

	#How to copy the executable code to bootable device and then test it
	To create a floppy disk image to 1.4mb size
		dd if=/dev/zero of=floppy.img bs=512 count=2880
	To copy the code to the boot sector of the floppy disk image file
		dd if=test.bin of=floppy.img
	To create a configuration file of boshsrc.txt
		reference: boshsrc.txt
	To test the programm
		bochs

	. bochs will search bochsrc.txt in current directoy

	
	#How to compile c source code with asm inline
	Compile c source code
	gcc -c -g -Os -m32 -ffreestanding -Wall -Werror test_print_with_inline_asm.c -o test_print_with_inline_asm.o
	. -m32: Generates code for the specific CPU architecture
	. -ffreestanding: A freestanding environment is one in which the standard library may not exist, and program startup may not necessarily be at ‘main’.
	** -fno-asynchronous-unwind-tables: http://stackoverflow.com/questions/26300819/why-gcc-compiled-c-program-needs-eh-frame-section
	   Disable generation of .en_frame section, which is something like 15%-20% increase to .text section

	Generate executable
	ld -static -Ttest_print_with_inline_asm.ld -nostdlib --nmagic -m elf_i386 test_print_with_inline_asm.o -o test_print_with_inline_asm.elf
	. -static: Do not link against shared libraries
	. -Ttest_print_with_inline_asm.ld: hint the linker to follow commands in linker script
	. -nostdlib: hint the linker to generate code by linking no standard C library startup functions
	. --nmagic: hint the linker to generate code without _start_SECTION and _stop_SECTION codes
	. -m elf_i386 hardware architecture of platform dependent file format to store executables

	Generate binary
	objcopy -O binary test_print_with_inline_asm.elf test_print_with_inline_asm.bin
