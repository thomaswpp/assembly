
.text
PrintNewLine:
	li $v0, 4
	la $a0, __PNL_newline
	syscall
	jr $ra
.data
	__PNL_newline: .asciiz "\n"
	
.text
PrintInt:
	li $v0, 4
	syscall
	
	move $a0, $a1
	li $v0, 1
	syscall
	
	jr $ra
	

.text
PromptInt:
	li $v0, 4
	syscall
	
	move $a0, $a1
	li $v0, 5
	syscall
		
	jr $ra
	
.text
PrintString:
	addi $v0, $zero, 4
	syscall
	jr $ra																																	
	
.text
Exit:
	li $v0, 10
	syscall	
																																															.															
