#n = prompt("enter the value to calculate the sum up to: ")
#total = 0; # Initial the total variable for sum
#for (i = 0; i < n; i++)
#{
	#total = total + i
#}
#print("Total = " + total);
.text
main:
	la $a0, prompt
	jal PrintInt
	move $s1, $v0
	li $s0, 0
	li $s2, 0 #inicializa o total
	
	start_loop:
		sle $t1, $s0, $s1
		beqz $t1, end_loop
		
		#code_block
		add $s2, $s2, $s0
		
		addi $s0, $s0, 1
		b start_loop	
	
	end_loop:
	
	la $a0, output
	move $a1, $s2
	jal PrintInt
	
	jal Exit
.data
	prompt: .asciiz "enter the value to calculate the sum up to: "	
	output: .asciiz "The final result is: "
	
.include "utils.asm"