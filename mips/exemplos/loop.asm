.data
	v: .word
.text
	li $t1, 1
	li $t2, 10
	li $t3, 0
	la $t4,v
	
	loop:
		sw $t1, 0($t4) 		#escrever na memorio
		addi $t4, $t4, 4 	#soma 4 ao endereço de memória
		addi $t3, $t3, 1	#o t3 é um contador do for	
		bne $t3, $t2, loop  	#compara se t3 != 10
	syscall
		
		