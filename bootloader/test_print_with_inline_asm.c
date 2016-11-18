__asm__(".code16gcc\n\t"
	"ljmp $0x0000, $main\n\t");

void print_something(const char* input_string)
{
	while(*input_string)
	{
		__asm__ __volatile__("movb %0, %%al\n\t"
					"movb $0x0e, %%ah\n\t"
					"int $0x10"
					: /* No output */
					: "a"(*input_string)
					: /* No clobbered register */
		);
		++input_string;
	}
}

int main(int argc, char** argv)
{
	char* hello_world = "Hello, World!";
	print_something(hello_world);
	return 0;
}

