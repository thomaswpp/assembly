
.text
main:
	la $s0, prompt
	jal PrintString
	
	
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
	PrintInt:
	# Print string. The string address is already in $a0
	li $v0, 4
	syscall
	# Print integer.The integer value is in $a1, and must
	# be first moved to $a0.
	move $a0, $a1
	li $v0, 1
	syscall
	#return
	jr $ra
	
	# print the value back to the user
	jal PrintNewLine
	la $a0, result
	move $a1, $s0
	jal PrintInt
	# call the Exit subprogram to exit
	jal Exit	
	
.text
	PrintString:
	addi $v0, $zero, 4
	syscall
	jr $ra	
	
.text
	Exit:
	li $v0, 10
	syscall