.data
		
hello:	.asciiz "Hello\n"
		
.text
	
main:			
	addi $v0, $zero, 161
	addi $a0, $zero, 2
	la $a1, hello_func
	syscall		
	jr $ra

	hello_func:
	addi $v0, $zero, 4
	la $a0, hello
	syscall	
	addi $v0, $zero, 162
	syscall
	add $a0, $v0, $zero
	addi $v0, $zero, 1	
	syscall
	jr $ra