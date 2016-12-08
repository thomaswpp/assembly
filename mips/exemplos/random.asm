li $v0, 41         #Service 41, random int
xor $a0, $a0, $a0  #Select random generator 0
syscall            #Generate random int (returns in $a0)

#li $v0, 1  #Service 1, print int
#syscall    #Print previously generated random int

#gera números dentro de um intervalo
li $v0, 42         #Service 42, random int
li $a0, 3	   #Select random generator 0
li $a1, 15
syscall            #Generate random int (returns in $a0)

li $v0, 1  #Service 1, print int
syscall    #Print previously generated random int
