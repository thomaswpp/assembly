.text
main:
	la $a0, prompt1
	li $a1, 80
	jal PromptString
	move $a0, $v0
	jal PrintString
	
	la $a0, prompt2
	li $a1, 80
	jal PromptString
	move $a0, $v0
	jal PrintString
	
	jal Exit
	
.data
	prompt1: .asciiz "Enter the first string: "
	prompt2: .asciiz "Enter the second string: "	
	
		
.text 
PromptString:
	add $sp, $sp, -12  # Push stack
	sw $ra, 0($sp)
	sw $a1, 4($sp)
	sw $s0, 8($sp)
	
	li $v0, 4      # Print the prompt
	syscall
	
	li $v0, 9        # Allocate memory
	lw $a0, 4($sp)
	syscall
	move $s0, $v0
	
	move $a0, $v0    # Read the string
	li $v0, 8
	lw $a1, 4($sp)
	syscall
	
	move $v0, $a0   # Save string address to return
	
	lw $ra, 0($sp)   # Pop stack
	lw $s0, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
.include "utils.asm"
	 				 				