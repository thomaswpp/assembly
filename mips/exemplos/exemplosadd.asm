#File name: exemplosadd.asm
#autor: Thomas William

.text
main:
	li $t1, 100
	li $t2, 50
	add $t0, $t1, $t2
	
	addi $t0, $t0, 50
	addiu $t0, $t2, -100
	addi $t1, $t2, 5647123