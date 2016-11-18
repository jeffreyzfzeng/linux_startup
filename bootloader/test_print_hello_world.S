.code16				#Generate 16bits real mode code
.text				#Code section

	.global _start;		#Code entry
_start:
	#Print 'H'
	movb $'H', %al
	movb $0x0e, %ah
	int $0x10

	#Print 'e'
	movb $'e', %al
	movb $0x0e, %ah
	int $0x10

	#Print 'l'
	movb $'l', %al
	movb $0x0e, %ah
	int $0x10

	#Print 'l'
	movb $'l', %al
	movb $0x0e, %ah
	int $0x10

	#Print 'o'
	movb $'o', %al
	movb $0x0e, %ah
	int $0x10

	#Print ','
	movb $',', %al
	movb $0x0e, %ah
	int $0x10

	#Print ' '
	movb $' ', %al
	movb $0x0e, %ah
	int $0x10

	#Print 'W'
	movb $'W', %al
	movb $0x0e, %ah
	int $0x10

	#Print 'o'
	movb $'o', %al
	movb $0x0e, %ah
	int $0x10

	#Print 'r'
	movb $'r', %al
	movb $0x0e, %ah
	int $0x10

	#Print 'l'
	movb $'l', %al
	movb $0x0e, %ah
	int $0x10

	#Print 'd'
	movb $'d', %al
	movb $0x0e, %ah
	int $0x10

	#Print '!'
	movb $'!', %al
	movb $0x0e, %ah
	int $0x10

	. = _start + 510	#Goto boot signature
	.byte 0x55
	.byte 0xaa
