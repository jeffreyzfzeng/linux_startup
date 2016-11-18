#include <string.h>

int main(int argc, char** argv)
{
	char* hello_world = "Hello world!\n";
	int hw_len = strlen(hello_world);
	int ret = 0;

	__asm__("movq $1, %%rax \n\t"
		"movq $1, %%rdi \n\t"
		"movq %1, %%rsi \n\t"
		"movq %2, %%rdx \n\t"
		"syscall"
		: "=g"(ret)
		: "g"(hello_world), "g"(hw_len));

	return 0;
}
