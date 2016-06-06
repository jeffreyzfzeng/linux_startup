# x86_assembly
# some testing source code for x86 assembly learning

# install nasm on Ubantu
sudo apt-get install nasm
# build source code
nasm -f elf64 -o your_code.o your_code.asm
# linking
ld -o your_code your_code.o

# how to compile call assembly function from c
# files
c_call_asm.c & asm_interface.asm
# compile assembly source code
nasm -f elf64 -o asm_interface.o asm_interface.asm
# compile c code with assembly source code
gcc c_call_asm.c asm_interface.o -o c_call_asm
