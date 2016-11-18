#if (grade > 100) || grade < 0)
#{
	#print("Grade must be between 0..100")
#}
#elseif (grade >= 90)
#{
	#print("Grade is A")
#}
#elseif (grade >= 80)
#{
	#print("Grade is B")
#}
#elseif (grade >= 70)
#{
	#print("Grade is C")
#}
#elseif (grade >= 60)
#{
	#print("Grade is D")
#}
#else{
	#print("Grade is F")
#}

.text
main:

	#if block
	lw $s0, num
	slti $t1, $s0, 0
	sgt $t2, $s0, 100
	or $t1, $t1, $t2
	beqz $t1, grade_A
	#invalid input block
	la $a0, InvalidInput
	jal PrintString
	b end_if
	grade_A:
	sgt $t1, $s0, 90
	beqz $t1, grade_B
	la $a0, OutputA
	jal PrintString
	b end_if
	grade_B:
	sgt $t1, $s0, 80
	beqz $t1, grade_C
	la $a0, OutputB
	jal PrintString
	b end_if
	grade_C:
	sge $t1, $s0, 70
	beqz $t1, grade_D
	la $a0, OutputC
	jal PrintString
	b end_if
	grade_D:
	sge $t1, $s0, 60
	beqz $t1, else
	la $a0, OutputD
	jal PrintString
	b end_if
	else:
	la $a0, OutputF
	jal PrintString
	b end_if
	end_if:
	jal Exit
.data
	num: .word 70
	InvalidInput: .asciiz "Number must be > 0 and < 100"
	OutputA: .asciiz "Grade is A"
	OutputB: .asciiz "Grade is B"
	OutputC: .asciiz "Grade is C"
	OutputD: .asciiz "Grade is D"
	OutputF: .asciiz "Grade is F"
	.include "utils.asm"
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	