#Programa-file: readstringuser.asm
#autor: Thomas William

.text
main:
	#Prompt para imprimir string
	li $v0, 4
	la $a0, prompt
	syscall
	
	#Lê a string
	li $v0, 8
	la $a0, input
	lw $a1, inputSize
	syscall
	
	#imprimir texto
	li $v0, 4
	la $a0, output
	syscall
	
	#imprimi o número
	li $v0, 4
	la $a0, input
	syscall
	
	#Exit the program
	li $v0, 10
	syscall
.data
input:	    .space 81
inputSize:  .word 80
prompt:	    .asciiz "Por favor entre com string: "
output:	    .asciiz "\nVocê digitou: "		