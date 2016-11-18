.code16				#generate 16-bit real mode code
.text				#code section
	.global _start;
_start:				#code entry point
	.=_start + 510		#move to 510th byte
	.byte 0x55		#boot signature
	.byte 0xaa		#boot signature
