global print_hello_world

section .text
print_hello_world:
	mov r10, rdi
	mov r11, rsi
	mov rax, 1
	mov rdi, 1
	mov rsi, r10
	mov rdx, r11
	syscall
	ret	
