#subprogram global main()
#{
	#register int multiplicand
	#register int multiplier
	#register int answer
	#m = prompt("Enter the multiplicand")
	#n = prompt("Enter the multiplier")
	#answer = Multiply(m, n)
	#print("The answer is: " + answer)
#}
#subprogram int multiply(int m, int n)
#{
	#if (n == 1)
	#return m;
	#return m + multiply(m,n-1)
#}

.text
.globl main
main:
	# register conventions
	# $s0 - m
	# $s1 - n
	# $s2 - answer
	
	la $a0, prompt1   # Get the multiplicand
	jal PromptInt
	move $s0, $v0
	
	la $a0, prompt2  # Get the multiplier
	jal PromptInt
	move $s1, $v0
	
	move $a0, $s0
	move $a1, $s1
	
	jal Multiply  # Do multiplication
	move $s2, $v0
	
	la $a0, result  #Print the answer
	move $a1, $s2
	jal PrintInt
	
	jal Exit
	
	Multiply:
		addi $sp, $sp,-8  #push the stack
		sw $a0, 4($sp)     #save $a0
		sw $ra, 0($sp)	#save the $ra
		
		seq $t0, $a1, 0
		addi, $v0, $zero, 0
		bnez $t0, Return
		
		addi $a1, $a1, -1  # n = (n - 1)
		jal Multiply       #recursive
		lw $a0, 4($sp)     # recursive m
		add $v0, $a0, $v0  # return m + multiply(m, n-1)
		
		Return:
		lw $ra, 0($sp)   #pop the stack
		addi $sp, $sp, 8
		jr $ra
		
		addi $sp, $sp, 8
		jal Exit	
	
.data
	prompt1: .asciiz "Enter the multiplicand: "
	prompt2: .asciiz "Enter the multiplier: "
	result: .ascii "The answer is: "
	
.include "utils.asm"



