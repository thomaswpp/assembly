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
bulletColor: 	 .word 0x00228b22  #green

#config aircraft
aircraft:	.space 16  #vector para amarzenar os endereço
aircraftX: 	.word 15   #posição inicial X do jogador
aircraftY:	.word 29   #Posição inicial Y do jogador
aircraftSize: 	.word 18   #Tamanho em largura do jogador
bulletAir:	.word 0	   #Address in memory of the trigger position
bulletAirExist: .byte 0    # 0 = no exist trigger, 1 = exist trigger
bulletAirMove: 	.byte 0    #Counter used for speed. It does not change
 

speedBullet:	.byte 1
 

#config invader
.align 2 	#
invader: 	   .space 140 #40 invader. MATRIZ 10X4
invaderWidth:      .word 26
invaderHeight:	   .word 12
invaderX: 	   .word 6
invaderY:	   .word 4
invadersLive:	   .space 40 	# 0 = muerto, 1 = vivo. vector lleno de unos
invadersLiveCount: .byte 40 	# count all invaders


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
	
	
mainLoop:
	jal drawAircraft
	#jal CreateInvadersLive
	jal drawInvaders
	jal createBulletAir
	jal moveBulletAir
	
	li $a0, 500
	li $v0, 32 #dekay
	syscall
	
	jal cleanInvaders
	jal moveAirCraftLeft
	jal moveInvadersLeft
	jal moveBulletAir
	li $a0, 500
	li $v0, 32 #dekay
	syscall
	jal moveAirCraftLeft
	jal moveInvadersLeft
	jal moveBulletAir
	li $a0, 500
	li $v0, 32 #dekay
	syscall
	jal moveAirCraftRight
	jal moveInvadersRight
	jal moveBulletAir
	li $a0, 500
	li $v0, 32 #dekay
	syscall
	jal moveAirCraftRight
	jal moveInvadersRight
	jal moveBulletAir
	li $a0, 500
	li $v0, 32 #dekay
	syscall
	jal moveAirCraftRight
	jal moveInvadersRight
	jal moveBulletAir
	li $a0, 500
	li $v0, 32 #dekay
	syscall
	jal moveAirCraftRight
	jal moveInvadersRight
	jal moveInvadersDown
	jal moveBulletAir
	jal ClearRegisters	
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
	
############################################
#		AIRCRAFT
############################################
#create aircrate in vector
createAircraft:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t1, aircraftSize
	lw $t3, aircraftX #x
	lw $t4, aircraftY #y
	move $a1, $t4
	li $t0, 0
createAircraftLoop:
		
	move $a0, $t3	
	jal CoordinateToAddress
	sw $v0, aircraft($t0)
	addiu $t3, $t3, 1
	addiu $t0, $t0, 1
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
	
	
drawAircraft:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	lw $t0, aircraftColor 
	lw $t1, aircraftSize
	
	lw $t3, aircraftX #x
	lw $t4, aircraftY #y
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
	lw $t1, aircraftSize
	
	lw $t3, aircraftX #x
	lw $t4, aircraftY #y
	
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

moveAirCraftLeft:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal cleanAirCraft
	
	lw $t1, aircraftSize
	lw $t3, aircraftX #x
	subi $t3, $t3, 2
	subi $t1, $t1, 2
	sw $t1, aircraftSize
	sw $t3, aircraftX
	jal drawAircraft

	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	
moveAirCraftRight:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal cleanAirCraft
	
	lw $t1, aircraftSize
	lw $t3, aircraftX #x
	addi $t3, $t3, 2
	addi $t1, $t1, 2
	sw $t1, aircraftSize
	sw $t3, aircraftX
	
	jal drawAircraft

	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra	
	
	
###########################################
#	    BULLET AIRCRAFT	
###########################################		
#Cria disparo na memória	
createBulletAir:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	#recuperar posição atual do jogador
	lw $t3, aircraftX #x
	lw $t4, aircraftY #y
	
	#ajustar para o tiro sair em cima do aircraft
	subi $t4, $t4, 2
	addiu $t3, $t3, 2
	
	#criar o endereço de memória
	move $a0, $t3 #x
	move $a1, $t4 #y
	jal CoordinateToAddress
	
	#salvando a posição atual da bala
	sw $v0, bulletAir
 	jal drawBulletAir
	
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
		
		
#Limpar disparo do jogador
cleanBulletAir:
	lw $t0 bulletAir
	lw $t1 backgroundColor
	sw $t1 0($t0)
	jr $ra
	

#Mostrar disparo do jogador
drawBulletAir:
	lw $t0, bulletAir
	lw $t1, bulletColor
	sw $t1, ($t0)
	jr $ra
	
#Move disparo para cima do jogador					
moveBulletAir:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	jal cleanBulletAir
	lw $t0, bulletColor 
	lw $t0, bulletAir
	subi $t0, $t0, 128
	sw $t0, bulletAir
	jal drawBulletAir
	
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	
	
	
			

#Create vector in memory the invades live ou dead.
CreateInvadersLive:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	li $t0, 0
	li $t1, 1
	
CreateInvadersLiveLoop:
	sb $t1, invadersLive($t0)
	addi $t0, $t0, 1
	bne $t0, 40, CreateInvadersLiveLoop
	
	#return							
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra	
	

	
drawInvaders:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	lw $t0, invaderColor 
	lw $t1, invaderWidth #width
	lw $t2, invaderHeight #height
	lw $t3, invaderX #x
	lw $t4, invaderY #y
	li $t5, 0 #count
	lw $t7, backgroundColor
drawInvadersLoop:
	#lb $t6, invadersLive($t5) 
	move $a0, $t3
	move $a1, $t4
	jal CoordinateToAddress
	#beqz $t6, invadersDead
	sw $t0, 0($v0)
	addiu $t3, $t3, 2
	addi $t5, $t5, 1
	bne $t3, $t1, drawInvadersLoop
	#passa para linha de baixo
	add $t4, $t4, 2
	lb $t3, invaderX
	bne $t4, $t2, drawInvadersLoop
		
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra		
invadersDead:
	sw $t7, 0($v0)
	addiu $t3, $t3, 2
	bne $t5, 40, drawInvadersLoop
	
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra

cleanInvaders:
   	add $sp, $sp, -4
    	sw $ra, 0($sp)
    	lw $t0, backgroundColor 
    	lw $t1, invaderWidth #width
    	lw $t2, invaderHeight #height
    	lw $t3, invaderX #x
    	lw $t4, invaderY #y
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


moveInvadersLeft:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal cleanInvaders
	
	lw $t1, invaderWidth
	lw $t3, invaderX
	subi $t1, $t1, 2
	subi $t3, $t3, 2
	sw $t1, invaderWidth
	sw $t3, invaderX
	
	jal drawInvaders
	
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra	
	
moveInvadersRight:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal cleanInvaders
	
	lw $t1, invaderWidth
	lw $t3, invaderX
	addi $t1, $t1, 2
	addi $t3, $t3, 2
	sw $t1, invaderWidth
	sw $t3, invaderX
	
	jal drawInvaders
	
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra	


	
moveInvadersDown:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal cleanInvaders
	
	lw $t2, invaderHeight #height
	lw $t4, invaderY #y
	addi $t2, $t2, 2
	addi $t4, $t4, 2
	sw $t2, invaderHeight
	sw $t4, invaderY
	
	jal drawInvaders
	
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



	

