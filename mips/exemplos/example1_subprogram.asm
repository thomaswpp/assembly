.text
main:
	#read an input value from the user
	li $v0, 4
	la $a0, prompt
	syscall
	li $v0, 5
	syscall
	move $s0, $v0
	
	#print the value back from the user
	li $v0, 4
	la $a0, result
	syscall
	li $v0, 1
	move $a0, $s0
	syscall
	
	#call the Exit subprogram to exit
	jal Exit
	
.data
	prompt: .asciiz "Please enter an integer: "
	result: .asciiz "\nYou entered: "
	
.text
Exit:
	li $v0, 10
	syscall