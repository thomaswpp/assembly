.text
.globl main
main:
	#y = a * x * x + b * x + c
	la $a0, prompt
	jal promptInt
	move $s0, $v0

	lw $t5, a
	lw $t6, b
	lw $t7, c
	
	mul $t0, $s0, $s0
	mul $t0, $t0, $t5
	mul $t1, $s0, $t6
	add $t0, $t0, $t1
	add $s1, $t0, $t7
	
	sw $s1, y
	
	#imprimi o y
	la $a0, result
	lw $a1, y
	
	
	
	jal PrintInt
	jal PrintNewLine
	#Exit program
	jal Exit
	
.data
a: .word 5
b: .word 2
c: .word 3
y: .word 0
prompt: .asciiz "Enter a value for x: "
result: .asciiz "The result is: "
.include "utils.asm"	
	
	 
	
	

