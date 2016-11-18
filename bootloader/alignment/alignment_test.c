#include <stdio.h>

struct aligned_16
{
	int int_aligned_16;
} __attribute__ ((aligned(16)));

struct aligned_2
{
	int int_aligned_2;
} __attribute__ ((aligned(2)));

struct unaligned
{
	int int_unaligned;
};

int main(int argc, char** argv)
{
	struct aligned_16 local_aligned_16;
	struct aligned_2 local_aligned_2;
	struct unaligned local_unaligned;
	
	printf("The length of aligned_16 struct is: %zu\n", sizeof(local_aligned_16));
	printf("The length of unaligned struct is: %zu\n", sizeof(local_unaligned));
	printf("The length of aligned_2 struct is: %zu\n", sizeof(local_aligned_2));
	
	return 0;
}
