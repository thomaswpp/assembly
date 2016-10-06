
# Program File: loopmsg.asm
# Author: Thomas William
.data
	print: .ascii "loop"
	v: .word
.text

	li $t1, 1
	li $t2, 10
	li $t3, 0
	la $t4, v
	li $v0, 4 #comando para imprimir um string com o syscall
	la $a0, print #o syscal vai imprimir o que está dentr
	
	loop:
		sw $t1, 0($t4)
		addi $t4, $t4, 4
		addi $t3, $t3, 1
		syscall		
		bne $t3, $t2, loop
		
		
			