#Programa File: readnumberuser
#autor: Thomas William
#Programa lê um inteiro de um usuário e printa esse valor na tela
.text
main:
	#Prompt para entrada de um inteiro
	li $v0, 4
	la $a0, prompt
	syscall
	
	#lê um inteiro e salva em $s0
	li $v0, 5
	syscall
	move $s0, $v0
	
	#Imprimi o texto
	li $v0, 4
	la $a0, output
	syscall
	
	#imprimi o número
	li $v0, 1
	move $a0, $s0
	syscall
	
	#Exit program
	li $v0, 10
	syscall 
	
.data
prompt: .asciiz "Por favor entre com o número: "
output: .asciiz "\nVocê digitou o número "