#autor: Thomas William
#main
#{
	#int x = prompt("Enter a value for x: ");
	#int y = 5 * x * x + 2 * x + 3;
	#print("The result is: " + y);
#}

.text
.globl main
main:
	#imprime texto
	addi $v0, $zero, 4
	la $a0, prompt
	syscall
	
	#lendo inteiro x
	add $v0, $zero, 5
	syscall
	move $s0, $v0
	
	#multiplicando 5 * x * x
	mul $t0, $s0, $s0
	mul $t0, $t0, 5
	#2 * x
	mul $t1, $s0, 2
	
	#somando
	add $t0, $t0, $t1
	addi $s1, $t0, 3
	
	#imprime texto
	addi $v0, $zero, 4
	la $a0, result
	syscall
	addi $v0, $zero, 1
	move $a0, $s1
	syscall
	
	#Exit program
	addi $v0, $zero, 10
	syscall
	
	
.data
prompt: .asciiz "Enter a value for x: "
result: .asciiz "The result is: "	