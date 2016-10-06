#autor: Thomas William

.text
.globl main
main:
	addi $s0, $zero, 10
	addi $s1, $zero, 3
	div $s2, $s0, $s1 #10/3
	mul $s2, $s2, $s1 #(10/3)*3
	
	#imprmindo resultado
	addi $v0, $zero, 4
	la $a0, result1
	syscall
	addi $v0, $zero, 1
	move $a0, $s2
	syscall
	
	
	mul $s2, $s0, $s1 #10*3
	div $s2, $s2, $s1 #(10*3)/3
	
	#imprmindo resultado
	addi $v0, $zero, 4
	la $a0, result2
	syscall
	addi $v0, $zero, 1
	move $a0, $s2
	syscall
	
	addi $v0, $zero, 10 #Exit program
	syscall
	
.data
result1: .asciiz "\n(10/3)*3 = "
result2: .asciiz "\n(10*3)/3 = "	