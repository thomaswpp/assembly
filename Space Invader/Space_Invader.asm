######################################################################
# 			SPACE INVADER!!!!                            #
######################################################################
#      Programmed by Thomas William and Henrique Apollonio           #
######################################################################
#	This program requires the Keyboard and Display MMIO          #
#       and the Bitmap Display to be connected to MIPS.              #
#								     #
#       Bitmap Display Settings:                                     #
#	Unit Width: 16						     #
#	Unit Height: 16						     #
#	Display Width: 512					     #
#	Display Height: 512					     #
#	Base Address for Display: 0x10008000 ($gp)		     #
######################################################################

.data

#Game Core information

#Screen 
screenWidth: 	.word 32
screenHeight: 	.word 32

speed:		.byte 60  #Each time you run the game loop. Milliseconds.

#Color
backgroundColor: .word 0x00000000  #black
borderColor:	 .word 0x00228b22  #green
invaderColor:	 .word 0x00ff0000  #red
aircraftColor:	 .word 0xcc6611  #green
#bulletColor: 	 .word 0x00228b22  #green

#config aircraft

aircraftX: 	.byte 15   #Player initial position
aircraftY:	.byte 29   #Player initial position
aircraftSize: 	.byte 18  
bulletAir:	.word 0	   #Address in memory of the trigger position
bulletAirExist: .byte 0    # 0 = no exist trigger, 1 = exist trigger
bulletAirMove: 	.byte 0    #Counter used for speed. It does not change
speedBullet:	.byte 1 

#config invader
.align 2 	#
invader: 	.space 140 #40 invader. MATRIZ 10X4
invaderWidth:	.byte 26
invaderHeight:	.byte 12
invaderX: 	.byte 6
invaderY:	.byte 4


#invader

teste: .asciiz "teste"
.text
.globl main
######################################################
# Fill Screen to Black, for reset
######################################################
main:
	jal background
	jal border
	jal drawAircraft
	jal drawInvaders
	li $a0, 500
	li $v0, 32
	syscall
	jal cleanInvaders
	jal cleanAirCraft
	jal ClearRegisters
	
mainLoop:
		
	b mainLoop
	
mainkey:
	jal getKey
	
mainMoveleft:
mainMoveRight:
		
		
	
background:
	lw $a0, backgroundColor
	lw $a1, screenWidth
	lw $a2, screenHeight
	mul $a2, $a1, $a2     #total de pixel
	mul $a2, $a2, 4       #align addresses	
	add $a2, $a2, $gp     #add base address of gp
	add $a1, $gp, $zero   #loop counter
backgroundLoop:
	sw $a0, 0($a1)
	addiu $a1, $a1, 4 
	bne $a1, $a2, backgroundLoop
	jr $ra
	
CoordinateToAddress:
	lw $v0, screenWidth 	#Store screen width into $v0
	mul $v0, $v0, $a1	#multiply by y position
	add $v0, $v0, $a0	#add the x position
	mul $v0, $v0, 4		#multiply by 4
	add $v0, $v0, $gp	#add global pointerfrom bitmap display
	jr $ra		


#Calculo do endereço da memória
#$a0 = X, $a1 = Y, $a2 = width or heigth
memoryAddress:
	lb $v0, screenWidth
	mulu $a1, $a1, $v0
	addu $v0, $a0, $a1
	sll $v0, $v0, 2
	addu $v0, $v0, $gp
	jr $ra
	
border:
	lw $t0, borderColor
	lw $t1, screenWidth
	lw $t2, screenHeight
	add $sp, $sp, -4
 	sw $ra, 0($sp)
	
	li $t3, 0 # x
	li $t4, 0 # y

borderLeft:
	move $a0, $t3
	move $a1, $t4	
	jal CoordinateToAddress
	sw $t0, 0($v0)
	addiu $t4, $t4, 1
	bne $t4, $t2, borderLeft
	
	li $t3, 31
	li $t4, 0
	
borderRight:
	move $a0, $t3
	move $a1, $t4
	jal CoordinateToAddress
	sw $t0, 0($v0)
	addiu $t4, $t4, 1
	bne $t4, $t2, borderRight

	li $t3, 0
	li $t4, 0
	move $a2, $t1 #width
borderUp:
	move $a0, $t3
	move $a1, $t4
	jal CoordinateToAddress
	sw $t0, 0($v0)
	addiu $t3, $t3, 1
	bne $t3, $t1, borderUp	

	li $t3, 0
	li $t4, 31

borderDown:
	move $a0, $t3
	move $a1, $t4
	jal CoordinateToAddress
	sw $t0, 0($v0)
	addiu $t3, $t3, 1
	bne $t3, $t1, borderDown
	
	#border return							
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra	
	
drawAircraft:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	li $t0, 0
	lw $t0, aircraftColor 
	lb $t1, aircraftSize
	
	lb $t3, aircraftX #x
	lb $t4, aircraftY #y
	move $a1, $t4
drawAircraftLoop:
	move $a0, $t3	
	jal CoordinateToAddress
	sw $t0, 0($v0)
	addiu $t3, $t3, 1
	bne $t3, $t1, drawAircraftLoop
	
	#gerar cabeça do aircraft
	subi $a0, $t3, 2
	subi $a1, $t4, 1
	jal CoordinateToAddress
	sw $t0, 0($v0)
	
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	
cleanAirCraft:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	li $t0, 0
	lw $t0, backgroundColor 
	lb $t1, aircraftSize
	
	lb $t3, aircraftX #x
	lb $t4, aircraftY #y
cleanAirCraftLoop:
	move $a0, $t3
	move $a1, $t4
	jal CoordinateToAddress
	sw $t0, 0($v0)
	addiu $t3, $t3, 1
	bne $t3, $t1, drawAircraftLoop
	
	#gerar cabeça do aircraft
	addi $a0, $t3, 1
	subi $a1, $t4, 1
	jal CoordinateToAddress
	sw $t0, 0($v0)
	
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra

		
	
drawInvaders:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	lw $t0, invaderColor 
	lb $t1, invaderWidth #width
	lb $t2, invaderHeight #height
	lb $t3, invaderX #x
	lb $t4, invaderY #y
drawInvadersLoop:
	move $a0, $t3
	move $a1, $t4
	jal CoordinateToAddress
	sw $t0, 0($v0)
	addiu $t3, $t3, 2
	bne $t3, $t1, drawInvadersLoop
	#passa para linha de baixo
	add $t4, $t4, 2
	lb $t3, invaderX
	bne $t4, $t2, drawInvadersLoop
		
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra		


moveInvaderLeft:

moveInvaderRight:


cleanInvaders:
   	add $sp, $sp, -4
    	sw $ra, 0($sp)
    	lw $t0, backgroundColor 
    	lb $t1, invaderWidth #width
    	lb $t2, invaderHeight #height
    	lb $t3, invaderX #x
    	lb $t4, invaderY #y
cleanInvadersLoop:
	move $a0, $t3
	move $a1, $t4
	jal CoordinateToAddress
	sw $t0, 0($v0)
	addiu $t3, $t3, 2
	bne $t3, $t1, drawInvadersLoop
	#passa para linha de baixo
	add $t4, $t4, 2
	lb $t3, invaderX
	bne $t4, $t2, drawInvadersLoop
		
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra		


	
				

getKey:
	lw $t0, 0xFFFF0004		#Load the pressed value (ASCII)
getRightKey:
	bne $t0, 100 getLeftKey
	li $v0, 0x01000000
	j getReturnKey
getLeftKey:
	bne $t0, 97 getTrigger
	li $v0, 0x02000000
	j getReturnKey
getTrigger:
	bne $t0, 32 getReturnKey
	li $v0, 0x03000000		
getReturnKey:
	jr $ra


ClearRegisters:

	li $v0, 0
	li $a0, 0
	li $a1, 0
	li $a2, 0
	li $a3, 0
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $t8, 0
	li $t9, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0		



	

