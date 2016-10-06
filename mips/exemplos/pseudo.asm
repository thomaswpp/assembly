#File name: pseudo code
#autor: Thomas William
#Pseudo Code
#	main
#	{
#		register int i = input("Please enter the first value to add: ");
#		register int j = input("Please enter the second value to add: ");
#		register int k = i + j;
#		print("The result is " + k);
#	}
.text
.global main
main:
	#registrer convencio
	#i is $s0
	#j is $s1
	#k is $s2
	#registre int i	= input("Please enter the first value to add: ");
	addi $v0, $zero, 4
	la $a0, prompt1
	syscall
	addi $v0, $zero, 5
	syscall
	move $s0, $v0
	
	# register int j =
	#input("Please enter the second value to add: ");
	addi $v0, $zero, 4
	la $a0, prompt2
	syscall
	addi $v0, $zero, 5
	syscall
	move $s1, $v0
	
	# register int k = i + j;
	add $s2, $s1, $s0
	
	#print("The result is " + k);
	addi $v0, $zero, 4
	la $a0, result
	syscall
	addi $v0, $zero, 1
	move $a0, $s2
	syscall
	
	#The end program
	addi $v0, $zero, 10
	syscall
	
.data
prompt1: .asciiz "Please enter the first value to add: "
prompt2: .asciiz "Please enter the second value to add: "
result: .asciiz "The result is "	