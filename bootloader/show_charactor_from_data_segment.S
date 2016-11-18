.code16				/* Indicate compiler to generate 16 bit real mode code */
.text				/* Code section */

	.global _start;		/* Code entry */
_start:
	jmp boot_entry
	.byte 'X'
	.byte 'Y'

boot_entry:
	movw $0x07c0, %ax	/* Assign %ax with section index 0x07c0 */
	movw %ax, %ds		/* Assign data section with section index 0x07c0 which will be converted to actual phycical address 0x07c0 * 16 */

	movb 0x02, %al		/* Copy charactor in DS:IP = 0x7c00 : 0x02 */
	movb $0x0e, %ah
	int $0x10

	movb 0x03, %al		/* Copy charactor in DS:IP = 0x7c00 : 0x03 */
	int $0x10

loop_entry:
	jmp loop_entry		/* Infinite loop */
	. = _start + 510	/* Boot signature */
	.byte 0x55
	.byte 0xaa
