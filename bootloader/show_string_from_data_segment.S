.code16						/* Indicate compiler to generate 16 bit real mode code */
.text						/* Code section */
	.global _start;				/* Code entry */
_start:
	jmp boot_entry
	hello_world: .asciz "Our boot loader start from here"
						/* String print to console */
	.macro PRINT
	print_start:
		lodsb				/* Copy charactor in %ds:%si to %al */
		cmpb $0, %al
		jz print_stop			/* Check end of the string */
		movb $0x0e, %ah
		int $0x10
		jmp print_start
	print_stop:
		ret
	.endm

boot_entry:
	xorw %ax, %ax
	movw %ax, %ds
	movw %ax, %si
	movw $0x07c0, %ax			/* Memory segment index to %ax */
	movw %ax, %ds				/* Convert to actual phycical memory address */
	movw $0x02, %si				/* Offset of the data segment, the start address of string */
	PRINT

loop_entry:
	jmp loop_entry
	. = _start + 510			/* boot signature */
	.byte 0x55
	.byte 0xaa
