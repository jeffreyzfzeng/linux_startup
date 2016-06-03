#include <string.h>

int main(int argc, char** argv)
{
	char* hello_world = "Hello world!\n";
	int hw_len = strlen(hello_world);
	print_hello_world(hello_world, hw_len);
	return 0;
}
