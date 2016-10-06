#File name: numberparorimpar
#autor: Thomas William
#main
#{
	#int i = prompt("Enter your number");
	#int j = i % 2;
	#print("A result of 0 is even, a result of 1 is odd: result = " + j;
#}

.text
.globl main
main:
	#significado
	#i is $t1
	#j is $t2
	#imprime texto
	li $v0, 4
	la $a0, prompt
	syscall
	
	#Read int
	li $v0, 5
	syscall
	move $t1, $v0
	
	#verificando se o número é par ou ímpar
	addi $t0, $zero, 2
	div $t2, $t1, $t0
	mfhi $t2  # Save o resto in $s1
	#rem $t2, $t1, 2
	
	#output
	li $v0, 4
	la $a0, output
	syscall
	li $v0, 1
	move $a0, $t2
	syscall
	
	#Exit program
	addi $v0, $zero, 10
	syscall

.data
prompt: .asciiz "Enter your number: "
output: .asciiz "A result of 0 is even, a result of 1 is odd: result = "
