#include<stdio.h>
#include<string.h>
#include<stdlib.h>


void add_normal()
{
	int a = 10, b = 20;
	asm("addl %%ebx, %%eax"
		: "=a"(a)
		: "a"(a), "b"(b)
		);  /* We shoudn’t list the input and output registers in this list. 
			Because, gcc knows that "asm" uses them 
			(because they are specified explicitly as constraints). 
			If the instructions use any other registers, implicitly or explicitly 
			(and the registers are not present either in input 
			or in the output constraint list) then those registers have to be 
			specified in the clobbered list. */
	printf("The result is: %d\n", a);
	return;
}

void add_atomic()
{
	int a = 10, b = 100;
	__asm__ __volatile__("lock;\n\t"
				"addl %1, %0;\n\t"
				: "=m"(a)		/* return value, it's a memory oprand */
				: "ir"(b), "m"(a)	/* input value, this first one indicates 
								it's a integer, the second one indicates
								it's a memory operand */
				:);			/* no clobber list */
	printf("The result is: %d\n", a);
	return;
}

void dec_compare()
{
	int a = 1;
	char b = 0;
	__asm__ __volatile__("decl %0; sete %1"
				: "=m"(a), "=q"(b)
				: "m"(a)
				: "memory"
				);
	printf("This result are: %d, %d\n", a, b);
	return;
}

void set_pos_bit()
{
	unsigned int pos = 10, src = 0;
	asm("btsl %1, %0"
		: "=m"(src)
		: "Ir"(pos)
		: "cc"
		);
	printf("The result of btsl is : %u\n", src);

	unsigned int dst = 0xFFFFFFFF;
	asm("btrl %1, %0"
		: "=m"(dst)
		: "Ir"(pos)
		: "cc");
	printf("The result of btrl is : %u\n", dst);
	return;
}

static inline char* strcpy_test(char* dst, const char* src)
{
	int d0, d1, d2;
	__asm__ __volatile__(	"1:\n\t"
				"lodsb\n\t"
				"stosb\n\t"
				"testb %%al, %%al\n\t"
				"jne 1b"
				: "=&S"(d0), "=&D"(d1), "=&a"(d2)
				: "0"(src), "1"(dst)
				: "memory");
	printf("d0: %x d1: %x, d2: %x\n", d0, d1, d2);
	return dst;
}

int main(int argc, char** argv)
{
	if (2 != argc)
	{
		char* warn_string = "Input parameters should be as follow:\n1: normal add\n2: atomic add\n3: decrease and compare\n4: set and reset bit in specific position\n5: string copy demo\n";
		int warn_len = strlen(warn_string);
		asm("movl $1, %%eax; \n\t"
			"movl $1, %%edi; \n\t"
			"movl %0, %%esi; \n\t"
			"movl %1, %%edx; \n\t"
			"syscall"
			:
			: "g"(warn_string), "g"(warn_len)
			:);
	}
	else
	{
		int choose = atoi(argv[1]);

		switch(choose)
		{
			case 1:
				add_normal();
				break;
			case 2:
				add_atomic();
				break;
			case 3:
				dec_compare();
				break;
			case 4:
				set_pos_bit();
				break;
			case 5:
			{
				char* src = "Hello world!";
				char dst[15] = {0};
				strcpy_test(dst, src);
				printf("%s\n", dst);
				break;
			}
			default:
				//TODO
				break;
		};
	}

	return 0;
}
