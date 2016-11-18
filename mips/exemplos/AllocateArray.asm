AllocateArray:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	mul $a0, $a0, $a1
	li $v0, 9
	syscall
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	