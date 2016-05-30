;;----------------------------------------------------------------;;
;; A string converse routine in learning assembly to familiar with
;; instructions of string operation
;; Author: 	Jin Feng
;; Email: 	feng.1.jin@nokia.com
;; Data: 	2016/06/03
;;----------------------------------------------------------------;;

;; Initialized data
;;----------------------------------------------------------------;;
section .data
	name:		db "Jin Feng"

;; Uninitialized data
;;----------------------------------------------------------------;;
section .bss
	con_name	resb 1

;; Code start from here
;;----------------------------------------------------------------;;
section .text
global _start
_start:
	mov rsi, name
	mov rdx, 0
	cld
next:
	lodsb
	cmp al, byte 0
	je print_conversed_name
	push rax 
	inc rdx
	jmp next

print_conversed_name:
	xor r10, r10
	mov r12, rdx
pop_stack:
	dec rdx
	pop rax
	mov [con_name+r10], al
	inc r10
	cmp rdx, 0
	jne pop_stack

	mov rax, 1
	mov rdi, 1
	mov rsi, con_name
	mov rdx, r12
	syscall	

the_end:
	mov rax, 60
	mov rdi, 0
	syscall

