# Filename: AverageGrade.asm
# Author:Charles Kann
# Date: 12/29/2013
# Purpose: Illustration of program to calculate a student grade
# Modification Log:
# 12/29/2014 - Initial release
#
# Pseudo Code
#global main()
#{
	# // The following variables are to be stored in data segment, and
	# // not simply used from a register. They must be read each time
	# // they are used, and saved when they are changed.
	#static volatile int numberOfEntries = 0
	#static volatile int total = 0
	#
	#//The following variable can be kept in a save register.
	#register int inputGrade # input grade from the user
	#register int average
	#
	#//Sentinel loop to get grades, calculate total.
	#inputGrade = prompt("Enter grade, or -1 when done")
	#while (inputGrade != -1)
	#{
		#numberOfEntries = numberOfEntries + 1
		#total = total + inputGrade
		#inputGrade = prompt("Enter grade, or -1 when done")
	#}
	#	
	#
	# Calculate average
	#average = total / numberOfEntries
	#
	#// Print average
	#print("Average = " + average)
	#
	#//Print grade if average is between 0 and 100, otherwise an error
	#if ((grade >= 0) & (grade <= 100))
	#{
		#if (grade >= 90)
		#{
			#print("Grade is A")
		#}
		#if (grade >= 80)
		#{
			#print("Grade is B")
		#}
		#if (grade >= 70)
		#{
			#print("Grade is C")
		#}
		#else
		#{
			#print("Grade is F")
		#}
	#}
	#else
	#{
		#print("The average is invalid")
	#}
	
.text
.globl main
main:
	la $a0, prompt
	jal PrintInt
	move $s0, $v0
	start_while:
	addi $t0, $zero, -1 # set condition $s0 != -1
	seq $t0, $t0, $s0
	xor $t0, $t0, 0x00000001
	beqz $t0, end_while # check condition to end loop
		
		la $t0, numberOfEntries
		lw $t1, 0($t0)
		addi $t1, $t1, 1
		sw $t1, 0($t0)
		
		la $t0, total
		lw $t1, 0($t0)
		add $t1, $t1, $s0
		sw $t1, 0($t0)
				
		la $a0, prompt
		jal PrintInt
		move $s0, $v0
		b start_while		
	end_while:
	
	la $t0, numberOfEntries #Calculate Average
	lw $t1, 0($t0)
	
	la $t0, total
	lw $t2, 0($t0)
	div $s1, $t2, $t1
	
	la $a0, avgOutput # Print the average
	move $a1, $s1
	jal PrintInt
	jal PrintNewLine
	
	sge $t0, $s1, 0 # Set the condition
			#(average >= 0) & (average =< 100)
			
	addi $t1, $zero, 100
	sle $t1, $s1, $t1			
	and $t0, $t0, $t1
	beqz $t0, AverageError # if Not AverageError
		sge $t0, $s1, 90
		beqz $t0, NotA
			la $a0, gradeA
			jal PrintString
			b EndPrintGrades
		NotA:
			sge $t0, $s1, 80
			beqz $t0, NotB
			la $a0, gradeB
			jal PrintString
			b EndPrintGrades
		NotB:
			seq $t0, $s1, 70
			beqz $t0, NotC
			la $a0, gradeC
			jal PrintString
			b EndPrintGrades
		NotC:
			la $a0, gradeF
			jal PrintString
		EndPrintGrades:
		b EndAverageError
	AverageError:   #else AverageError
	
		la $a0, invalidAvg
		jal PrintString
	
	EndAverageError: 


	
	jal Exit
	
.data
	numberOfEntries:.word 0
	total: .word 0
	average:.word
	prompt: .asciiz "Enter grade, or -1 when done: "
	avgOutput: .asciiz "The average is "
	gradeA: .asciiz "The grades is an A"
	gradeB: .asciiz "The grade is a B"
	gradeC: .asciiz "The grade is a C"
	gradeF: .asciiz "The grade is a F"
	invalidAvg: .asciiz "The average is invalid"
	
.include "utils.asm"	









