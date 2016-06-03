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

# how to compile call c function from assembly
# files
asm_call_c.asm & c_interface.c
# compile assembly source code
nasm -f elf64 -o asm_call_c.o asm_call_c.asm
# compile c code
gcc -o c_interface.o -c c_interface.c
# linking
ld -dynamic-linker /lib64/ld-linux-x86-64.so.2 -lc c_interface.o asm_call_c.o -o asm_call_c

# how to compile call inline asm function
gcc call_asm_directly_in_c.c -o call_asm_directly_in_c
