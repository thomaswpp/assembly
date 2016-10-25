.text
main:

	li $v0, 4
	la $a0, prompt
	syscall
	li $v0, 5
	syscall
	move $s0, $v0
	
	jal PrintNewLine
	li $v0, 4
	la $a0, result
	syscall
	li $v0, 1
	move $a0, $s0
	syscall
	jal Exit	
	
	
.data
	prompt: .asciiz "Please enter an integer: "
	result: .asciiz "You entered: "	
	
.text
	PrintNewLine:
	li $v0, 4
	la $a0, __PNL_newline
	syscall
	jr $ra
.data
	__PNL_newline:.asciiz "\n"
	
.text
	Exit:
	li $v0, 10
	syscall			