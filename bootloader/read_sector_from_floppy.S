/* There are 3 sectors in our floppy, in this example,	*/
/* we use BIOS interrupt 0x10 and function code 0x02 	*/
/* to read the 2nd and the 3rd sector from floppy	*/

.code16							/* Indicate compiler to generate 16 bit real mode code */
.text							/* Code section */

.global _start;						/* Code entry */
_start:
	jmp boot_entry
	welcome_floppy: .asciz "Our boot loader start from here\n\r"
	read_fail: .asciz "Read sector fail\n\r"

	PRINT:						/* Macro to print string */
		print_start:
			lodsb				/* Load charactor at %ds:%si to %al */
			cmpb $0, %al			/* Check end of string */
			jz print_end
			movb $0x0e, %ah			/* Function code of print charactor */
			int $0x10			/* BIOS interrupt */
			jmp print_start
		print_end:
			ret

	.macro READ_SECTOR sector_index			/* Macro to read specified sector */
		movb $0x02, %ah				/* Function code to read sector */
		movb $0x01, %al				/* Sector to read count */
		movb $0x00, %ch				/* Cylinder, here is 0x00 */
		movb \sector_index, %cl			/* Sector start index */
		movb $0x00, %dh				/* Head, here is 0x00 */
		movb $0x00, %dl				/* Drive, floppy 0x00, HDD 0x80 */
		movw $0x0800, %bx			/* Save the sector to memory at 0x0800 */				
		movw %bx, %es				/* Set the physical address of buffer, actual physical address will be converted to 0x8000 */
		xorw %bx, %bx				/* Set the %bx as 0 */
		int $0x13				/* BOIS interrupt */
		jc read_sector_fail			/* Read fail if CF not 0 */
	.endm


boot_entry:
	movw $0x07c0, %ax				/* Memory segment index 0x07c0 to %ax */
	movw %ax, %ds					/* Set data segment, actual physical address will be converted to 0x7c00 */
	movw $(welcome_floppy - _start), %si					/* Set the offset, prepare to print information in the first sector */
	call PRINT

	READ_SECTOR $2					/* Read the second sector */
	movw $0x0800, %ax
	movw %ax, %ds
	movw $0x0, %si
	call PRINT

	READ_SECTOR $3					/* Read the third sector */
	movw $0x0800, %ax
	movw %ax, %ds
	movw $0x0, %si
	call PRINT

loop_entry:
	jmp loop_entry					/* Stay at infinite loop */ 

read_sector_fail:
	pushw %ax
	movw $0x07c0, %ax
	movw %ax, %ds
	movw $(read_fail - _start), %si
	call PRINT
	popw %ax

boot_signature:
	. = _start + 510				/* Boot signature */
	.word 0xaa55

second_sector:						/* Second sector */
	welcome_second: .asciz "It's the second sector of our floppy\n\r"
	. = second_sector + 512

third_sector:						/* Third sector */
	welcome_third: .asciz "It's the third sector of our floppy\n\r"
	. = third_sector + 512
