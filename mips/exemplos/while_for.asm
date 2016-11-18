#int n = prompt("Enter a value for the summation n, -1 to stop");
#while (n != -1)
#{
#	if (n < -1)
	#{
		#print("Negative input is invalid");
	#}
	#else
	#{
		#int total = 0
		#for (int i = 0; i < n; i++)
		#{
			#total = total + i;
		#}
		#print("The summation is " + total);
	#}
#}

.text
main:
	la $a0, prompt
	jal PromptInt
	move $s0, $v0
	start_loop:
		sne $t1, $s0, -1
		beqz $t1, end_loop
		slti $t1, $s0, -1
		beqz $t1, else
		la $a0, error
		jal PrintString
		b end_if
		else:
		li $s1, 0 #inicializa total
		li $s2, 0 #inicialia o i
		start_for:
			slt $t1, $s2, $s0
			beqz $t1, end_for
			add $s1, $s1, $s2
			addi $s2, $s2, 1
			b start_for			
		
		end_for:
		
		la $a0, output
		move $a1, $s2
		jal PrintInt	
		
			
		end_if:
		
		la $a0, prompt
		move $a1, $s1
		jal PromptInt
		move $s0, $v0
		b start_loop
		
	end_loop:
	jal Exit
	
.data
	prompt: .asciiz "\nEnter an integer, -1 to stop: "
	error: .asciiz "\nValues for n must be > 0"
	output: .asciiz "\nThe total is: "
.include "utils.asm"	
		
