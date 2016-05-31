# x86_assembly
some testing source code for x86 assembly learning

Install nasm on Ubantu

sudo apt-get install nasm

Build source code

nasm -f elf64 -o your_code.o your_code.asm

ld -o your_code your_code.o
