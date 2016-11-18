.text
	#if (num > 0)
	lw $t0, num
	sgt $t1, $t0, $zero
	beqz $t1, end_if
	
	la $a0, PositiveNumber
	jal PrintString	
	
	end_if:
	jal Exit
	
.data
	num: .word 5
	PositiveNumber: .asciiz "Number is positive"
	.include "utils.asm"	
	