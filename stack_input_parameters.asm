;; To understand how routine get input parameters in assembly
;; Author: feng.1.jin@nokia
;; Data  : 2016/06/01

;; Data section with initialized variable
section .data
	msg_args_limit: 	db `Input parameters must be one\n`
	msg_args_len:		equ $-msg_args_limit
	buff_app_name: 		db 0
	buff_1st_arg: 		db 0

;; Code section
section .text
	global _start
_start:
	;; store argc to rcx
	pop rcx
	;; check the number of input parameters
	cmp rcx, 2
	;; if number of input parameter is not 1, print the limitation of input parameter
	jne input_parameter_error
	;; store the first parameter, application name
	pop rsi
	mov [buff_app_name], rsi
	;; measure the length of application name
	call measure_len
	;; return value saved in rax, copy it to rdx
	mov rdx, rax
	;; prepare for printing
	mov rsi, [buff_app_name]
	;; print application name
	call print_parameter
	
	;; store the second parameter, user input parameter
	pop rsi
	mov [buff_1st_arg], rsi
	call measure_len
	mov rdx, rax
	mov rsi, [buff_1st_arg]
	call print_parameter
	
	jmp end_of
	
measure_len:
	xor rax, rax
next:
	cmp [rsi], byte 0
	je ret_measure
	inc rsi
	inc rax
	jmp next

ret_measure:
	ret
	
	
input_parameter_error:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg_args_limit
	mov rdx, msg_args_len
	syscall
	jmp end_of
	
print_parameter:
	mov rax, 1
	mov rdi, 1
	syscall
	ret
	
end_of:
	mov rax, 60
	mov rdi, 0
	syscall
	