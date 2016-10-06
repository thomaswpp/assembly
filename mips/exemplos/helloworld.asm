.data 	#define um seção de dados
	Hello: .asciiz "Hello World"

.text #define um seção de instruções
	main:

		li $v0, 4  	# 4 indica print string
		la $a0, Hello	#load o endereço de hello in $a0
		syscall		#print hello 
	
		li $v0, 10  #exit program
		syscall	