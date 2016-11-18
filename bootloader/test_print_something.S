.code16			#Indicate compiler to generate 16bit real mode code
.text			#Code section

	.global _start;
_start:			#Code entry point

#In this example I will print a charactor on TTY using BIOS interrupt 0x10
#The detail inforation of BIOS interrupt 0x10 could be found in following link:
#             https://en.wikipedia.org/wiki/INT_10H

	movb $'!', %al			#The charactor to print
	movb $0x0e, %ah			#The function
	int $0x10			#Call BOIS interrupt

	. = _start + 510		#Start of boot signature
	.byte 0x55			#Boot signature
	.byte 0xaa			#Boot signature
