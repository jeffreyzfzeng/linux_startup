ENTRY(main);
SECTIONS
{
	. = 0x7c00;
	.text : AT(0x7c00)
	{
		*(.text);
	}
	.boot_signature : AT(0x7dfe)
	{
		SHORT(0xaa55);
	}
}

