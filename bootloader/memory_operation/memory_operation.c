/*
 * memset function
 */
void memset_local(void* dst, char* charactor, int size)
{
	__asm__ __volatile__(	"mov %1, %%rdi\n\t"
				"push %%rcx\n\t"
				"imull $0x01010101, %%eax\n\t"
				"shrl $2, %%ecx\n\t"
				"rep; stosl\n\t"
				"pop %%rcx\n\t"
				"andl $3, %%ecx\n\t"
				"rep; stosb\n\t"
				:"=m"(dst)				/* output */
				:"r"(dst), "a"(charactor), "c"(size)	/* input */
			);
}

/*
 * memcpy function
 */
void memcpy_local(void* dst, void* src, int size)
{
	__asm__ __volatile__(	"mov %1, %%rdi;"
				"mov %2, %%rsi;"
				"push %%rcx;"
				"shrl $2, %%ecx;"
				"rep; movsl;"
				"pop %%rcx;"
				"andl $3, %%ecx;"
				"rep; movsb"
				:"=m"(dst)				/* output */
				:"r"(dst), "r"(src), "c"(size)		/* input */
			);
}

#include <stdio.h>
#include <string.h>

int main()
{
	char* verify_block = "This is a block for memory verification!";
	int block_length = strlen(verify_block);
	char* memset_test_block = (char*)malloc(sizeof(char)*block_length);
	strncpy(memset_test_block, verify_block, block_length);
	printf("Before memory initialization, the content of the block as follow:\n%s\n", memset_test_block);
	memset_local((void*)memset_test_block, (char*)'a', block_length);
	printf("After memory initialization, the content of the block as follow: \n%s\n", memset_test_block);
	free(memset_test_block);
	
	char* memcpy_test_block = (char*)malloc(sizeof(char)*block_length);
	memset_local((void*)memcpy_test_block, (char*)0, block_length);
	memcpy_local(memcpy_test_block, verify_block, block_length);
	printf("After memory copy, the content of the block as follow: \n%s\n", memcpy_test_block);
	return 0;
}
