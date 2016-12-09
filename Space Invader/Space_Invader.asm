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

.include "macros.asm"

.data

#Game Core information

#Screen 
screenWidth: 	.word 32
screenHeight: 	.word 32

speed:		.byte 60  #Each time you run the game loop. Milliseconds.

#Color
backgroundColor: 	.word 0x00000000  #black
borderColor:	 	.word 0x00228b22  #green
invaderColor:	 	.word 0x00ff0000  #red
aircraftColor:	 	.word 0xcc6611    #green
bulletColor: 	 	.word 0x00228b22  #green
bulletInvaderColor: 	.word 0x00ffff00 

#config aircraft
aircraft:		.space 16  #vector para amarzenar os endereço
aircraftX: 		.byte 15   #posição inicial X do jogador
aircraftY:		.byte 29   #Posição inicial Y do jogador
aircraftSize: 		.byte 18   #Tamanho em largura do jogador
aircraftLive:		.byte 3    #começa com 3 vidas
bulletAir:		.word 0	   #Address in memory of the trigger position
bulletAirExist: 	.byte 0    # 0 = no exist trigger, 1 = exist trigger
bulletAirMove: 		.byte 0    #Counter used for speed. It does not change
bulletAirSpeed:		.byte 1	   #Tempo para mover o disparo 60ms*1 = 60ms
bulletAirCountMove: 	.byte 0 

#config invader
.align 2 	#
invaders: 	   	.space 160 	#40 invader. MATRIZ 10X4
invaderSize:		.byte 40
invaderWidth:      	.byte 26
invaderHeight:	   	.byte 10
invaderLive:	   	.space 40 	# 0 = dead, 1 = live in vector
invaderLiveCount: 	.byte 40 	# count all invaders
invaderSpeed:		.byte 12	# 60ms x 12 = 720ms
invaderCountMove:	.byte 0		#contar os loop paea mover os invaders pelo tempo
invaderX: 	  	.byte 6  	#precisa começar no 6
invaderY:	   	.byte 2
invaderDirection: 	.byte 0 	# 0 = left, 1 = right
bulletInvader:	   	.word 0		#Address in memory of the trigger position
bulletInvaderExist: 	.byte 0   	# 0 = no exist trigger, 1 = exist trigger
bulletInvaderMove: 	.byte 0    	#Counter used for speed. It does not change
bulletInvaderSpeed: 	.byte 1 	#Tempo para mover o disparo 60ms*1 = 60ms
bulletInvaderCountMove: .byte 0


.text
.globl main
######################################################
# Fill Screen to Black, for reset
######################################################
main:
	jal background
	jal border
	jal createAircraft
	jal drawAircraft
	jal createInvaders
	jal drawInvaders
	
mainLoop:
	jal createBulletInvader
	jal moveBulletAir
	jal moveBulletInvader
	jal moveInvaders
	
	
	jal ClearRegisters
	
	lb $t1, speed
	sleep($t1)
	
	lw $t0, 0xFFFF0000		
	blez $t0, mainLoop

#função main para obter a tecla pressionada		
mainkey:
	jal getKey
	move $t0, $v0	

#função main para mover o jogador para esquerda		
mainMoveAirLeft:
	bne $t0, 0x02000000, mainMoveAirRight # A
	jal moveAircraftLeft
	j mainLoop

#função main para mover o jogador para 	direita
mainMoveAirRight:
	bne $t0, 0x01000000 mainBulletAir # D	
	jal moveAircraftRight
	j mainLoop

#função main para criar o disparo do jogador	
mainBulletAir:
	bne $t0, 0x03000000 mainLoop # space
	jal createBulletAir
	j mainLoop
	
		
	
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
	
	lb $t1, aircraftSize
	lb $t3, aircraftX #x
	lb $t4, aircraftY #y
	move $a1, $t4
	li $t0, 0
createAircraftLoop:
		
	move $a0, $t3	
	jal CoordinateToAddress
	sw $v0, aircraft($t0)
	addiu $t3, $t3, 1
	addiu $t0, $t0, 4
	bne $t3, $t1, createAircraftLoop
	
	#gerar cabeça do aircraft
	subi $a0, $t3, 2
	subi $a1, $t4, 1
	jal CoordinateToAddress
	sw $v0, aircraft($t0)
	
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	
#desenhar na tela o jogador
drawAircraft:
	add $sp, $sp, -4
	sw $ra, 0($sp)	
	li $t0, 0
	lw $t1, aircraftColor
	
drawAircraftLoop:	
	
	lw $t2, aircraft($t0)
	sw $t1, 0($t2)  
	addi $t0, $t0, 4
	bne $t0, 16, drawAircraftLoop
					
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra	
	
	
#limpar da tela o jogador	
cleanAircraft:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	li $t0, 0
	lw $t1, backgroundColor 
	
cleanAircraftLoop:

	lw $t2, aircraft($t0)
	sw $t1, 0($t2)  
	addi $t0, $t0, 4
	bne $t0, 16, cleanAircraftLoop
	
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	
#mudar a cor do jogador quando foi atingido	
changeColorAir:
	li $t0, 0x006666FF
	sw $t0,	aircraftColor
	jal drawAircraft
	jal endBulletInvader	
		
#mover o jogador para esquerda							
moveAircraftLeft:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal cleanAircraft
	
	li $t0, 0
	lb $t1, aircraftSize
	lb $t3, aircraftX #x
	
moveAircraftLeftLoop:

	lw $t2, aircraft($t0)
	beq $t3, 4, returnAircraftLeft #limite máximo para esquerda
	subi $t2, $t2, 4
	sw $t2, aircraft($t0)
	addi $t0, $t0, 4
	bne $t0, 16, moveAircraftLeftLoop
	
	#ajustando os valores de inicio e fim do jogador
	subi $t1, $t1, 1
	subi $t3, $t3, 1
	sb $t1, aircraftSize
	sb $t3, aircraftX
	
	jal drawAircraft

returnAircraftLeft:
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra

	
#mover o jogador para direita			
moveAircraftRight:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal cleanAircraft
	
	li $t0, 0
	lb $t1, aircraftSize
	lb $t3, aircraftX #x
	
moveAircraftRightLoop:

	lw $t2, aircraft($t0)
	beq $t3, 26, returnAircraftRight #limite máximo para direita
	addi $t2, $t2, 4
	sw $t2, aircraft($t0)
	addi $t0, $t0, 4
	bne $t0, 16, moveAircraftRightLoop
	
	#ajustando coordenadas X do jogador
	addi $t1, $t1, 1
	addi $t3, $t3, 1
	sb $t1, aircraftSize
	sb $t3, aircraftX
	
	jal drawAircraft

returnAircraftRight:
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
	
	#checar se disparo do jogador existe, se sim não pode disparar novamente
	lb $t0, bulletAirExist
	beq $t0, 1, returnCreateBulletAir
	
	#recuperar posição atual do jogador
	lb $t3, aircraftX #x
	lb $t4, aircraftY #y
	
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
 	
 	li $t0, 1
 	sb $t0, bulletAirExist
	
returnCreateBulletAir:
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
		
#Limpar disparo do jogador
cleanBulletAir:
	lw $t0, bulletAir
	lw $t1, backgroundColor
	sw $t1, 0($t0)
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
	
	#checar se disparo do jogador não existe, se não, retorna
	lb $t0, bulletAirExist
	beq $t0, 0, returnCreateBulletAir
	
	
	#controlando o tempo de movimentação do disparo
	lb $t0, bulletAirSpeed
	lb $t1, bulletAirCountMove
	addi $t1, $t1, 1
	sb $t1, bulletAirCountMove
	bne $t1, $t0, returnMoveBulletAir
	li $t1, 0
	sb $t1, bulletAirCountMove
	
	
	jal cleanBulletAir
	
	jal collisionsBulletAir
	
	lw $t0, bulletAir
	subi $t0, $t0, 128
	sw $t0, bulletAir
	
	jal drawBulletAir
	
returnMoveBulletAir:
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	
#Função que finaliza o tiro do jogador
endBulletAir:
	li $t0, 0
 	sb $t0, bulletAirExist
 	sb $t0, bulletAirMove  
	jal cleanBulletAir
	j mainLoop


	
###########################################
#	    INVADERS	
###########################################
#create invaders in vector
createInvaders:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	 
	lb $t1, invaderWidth #width
	lb $t2, invaderHeight #height
	lb $t3, invaderX #x
	lb $t4, invaderY #y
	li $t5, 0 #count
	li $t6, 1
createInvadersLoop:
	move $a0, $t3
	move $a1, $t4
	jal CoordinateToAddress
	sw $v0, invaders($t5)
	addi $t5, $t5, 4
	addiu $t3, $t3, 2
	sw $t6, invaderLive($t3)     #setar 1 para os invaders vivos
	bne $t3, $t1, createInvadersLoop
	add $t4, $t4, 2
	lb $t3, invaderX
	bne $t4, $t2, createInvadersLoop
	
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra


drawInvaders:
	add $sp, $sp, -4
	sw $ra, 0($sp)	
	li $t0, 0
	lw $t1, invaderColor
	lb $t4, invaderSize
	li $t5, 0
drawInvadersLoop:
	lw $t2, invaders($t0)
	sw $t1, 0($t2)  
	addi $t0, $t0, 4
	addi $t5 $t5 1
	bne $t5, $t4, drawInvadersLoop
					
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra	
	
cleanInvaders:
	add $sp, $sp, -4
	sw $ra, 0($sp)	
	li $t0, 0
	lw $t1, backgroundColor
	lb $t4, invaderSize
	li $t5, 0
cleanInvadersLoop:
	lw $t2, invaders($t0)
	sw $t1, 0($t2)  
	addi $t0, $t0, 4
	addi $t5 $t5 1
	bne $t5, $t4, cleanInvadersLoop
					
	#return
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra	
	
		
moveInvaders:
	#controlando a velocidade de movimentação
	lb $t0, invaderCountMove
	lb $t2, invaderSpeed
	addi $t0, $t0, 1
	sb $t0, invaderCountMove
	bne $t0, $t2, returnMoveInvaders
	li $t0, 0
	sb $t0, invaderCountMove
	
	lb $t1, invaderDirection
	beqz $t1, moveInvadersLeft
	beq $t1, 1, moveInvadersRight
returnMoveInvaders:
	jr $ra

#mover o invasor para esquerda
moveInvadersLeft:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	#recuperar a posição atual dos invaders
	lb $t3, invaderX
	beq $t3, 4, moveInvadersDownLeft #limite máximo do invaders
	
	jal cleanInvaders
	
	#moviemntar o eixo X inicial e final
	lb $t1, invaderWidth
	lb $t3, invaderX 	#para evitar lixo da função clean
	lb $t4, invaderSize
	li $t0, 0
	li $t5, 0
moveInvadersLeftLoop:
	lw $t2, invaders($t0)
	subi $t2, $t2, 4
	sw $t2, invaders($t0)
	addi $t0, $t0, 4
	addi $t5, $t5, 1
	bne $t5, $t4, moveInvadersLeftLoop
	
	
	subi $t1, $t1, 1
	subi $t3, $t3, 1
	
	#reescrever o valores de volta
	sb $t1, invaderWidth
	sb $t3, invaderX
	
	jal drawInvaders
	
returnInvadersLeft:
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra	


#mover o invasor para direita
moveInvadersRight:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	#recuperar a posição atual dos invaders
	lb $t3, invaderX
	beq $t3, 10, moveInvadersDownRight #limite máximo do invaders
	
	jal cleanInvaders
	
	#moviemntar o eixo X inicial e final
	lb $t1, invaderWidth
	lb $t3, invaderX 	#para evitar lixo da função clean
	lb $t4, invaderSize
	li $t0, 0
	li $t5, 0
moveInvadersRightLoop:
	lw $t2, invaders($t0)
	addi $t2, $t2, 4
	sw $t2, invaders($t0)
	addi $t0, $t0, 4
	addi $t5, $t5, 1
	bne $t5, $t4, moveInvadersRightLoop
	
	
	addi $t1, $t1, 1
	addi $t3, $t3, 1
	
	#reescrever o valores de volta
	sb $t1, invaderWidth
	sb $t3, invaderX
	
	jal drawInvaders
	
returnInvadersRight:
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra	



moveInvadersDownLeft:
	li $t1, 1
	sb $t1, invaderDirection
	b moveInvadersDown
	
moveInvadersDownRight:
	li $t1, 0
	sb $t1, invaderDirection
	b moveInvadersDown

moveInvadersDown:
	#add $sp, $sp, -4
	#sw $ra, 0($sp)
	
	lb $t4, invaderY #y
	addi $t4, $t4, 1	#verificar se o jogador perdeu
	beq $t4, 16, gameOver
	
	jal cleanInvaders
	lb $t4, invaderSize	
	li $t0, 0
	li $t5, 0
moveInvadersDownLoop:
	lw $t2, invaders($t0)
	addi $t2, $t2, 128
	sw $t2, invaders($t0)
	addi $t0, $t0, 4
	addi $t5, $t5, 1
	bne $t5, $t4, moveInvadersDownLoop	
	
	lb $t2, invaderHeight #height
	lb $t4, invaderY #y #para evitar erro de lixo vindo da função clean
	addi $t2, $t2, 1
	addi $t4, $t4, 1
	sb $t2, invaderHeight
	sb $t4, invaderY
	
	jal drawInvaders
	
returnInvadersDown:
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra	


########################################
########################################
#	DEAD INVADER
########################################
deadInvader:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t0, bulletAir
	subi $t0, $t0, 128
	
	lb $t1, invaderLiveCount
	
	li $t2, 0 #contar bytes
	li $t3, 0 #contador
deadInvaderLoop:
	lw $t4, invaders($t2)
	beq $t0, $t4, eliminarInvader
	addi $t2, $t2, 4
	addi $t3, $t3, 1
	bne $t3, $t1, deadInvaderLoop
	
eliminarInvader:
	subi $t1, $t1, 1
	sb $t1, invaderLiveCount
	li $t1, 0
	sw $t1, invaderLive($t3)
	b endBulletAir	 	 
returnDeadInvader:
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra	


###########################################
###########################################
#   FUNÇÕES DE DISPAROS DOS INVADERS
###########################################				
#criar bala em um vetor
createBulletInvader:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	#verificar se o disparo não existe
	lb $t0, bulletInvaderExist 
	beq $t0, 1, returnCreateBulletInvader 
	
	#recuperar posição atual dos invaders
	lb $t4, invaderY #y
	lb $t1, invaderWidth
	lb $t3, invaderX
	
	#gera números dentro de um intervalo
	li $v0, 42          	#Service 42, random int
	move $a0, $t3   	#Select random generator 0
	move $a1, $t1
	syscall            	#Generate random int (returns in $a0)
	
	#criar o endereço de memória
	move $a1, $t4 #y
	jal CoordinateToAddress
	
	#salvando a posição atual da bala
	sw $v0, bulletInvader
	
 	jal drawBulletInvader
	
	li $t0, 1
 	sb $t0, bulletInvaderExist
	
returnCreateBulletInvader:
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra	
	

#Limpar disparo do jogador
cleanBulletInvader:
	lw $t0 bulletInvader
	lw $t1 backgroundColor
	sw $t1 0($t0)
	jr $ra
	

#Mostrar disparo do jogador
drawBulletInvader:
	lw $t0, bulletInvader
	lw $t1, bulletInvaderColor
	sw $t1, 0($t0)
	jr $ra	

#Move disparo para baixo
moveBulletInvader:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	#verificar se o disparo existe
	lb $t0, bulletInvaderExist 
	beqz $t0, returnBulletInvader
	
	#controlando o tempo de movimentação do disparo
	lb $t0, bulletInvaderSpeed
	lb $t1, bulletInvaderCountMove
	addi $t1, $t1, 1
	sb $t1, bulletInvaderCountMove
	bne $t1, $t0, returnBulletInvader
	li $t1, 0
	sb $t1, bulletInvaderCountMove
			
	jal cleanBulletInvader
	
	jal collisionsBulletInvaders
	
	lw $t0, bulletInvader
	addi $t0, $t0, 128
	sw $t0, bulletInvader
	
	jal drawBulletInvader
	
returnBulletInvader:
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	
#função que finaliza o disparo do invader	
endBulletInvader:
	li $t0, 0
 	sb $t0, bulletInvaderExist
 	sb $t0, bulletInvaderMove 
	jal cleanBulletInvader
	j mainLoop


##################################################
##################################################
#      FUNÇÕES VERIFICA COLISÕES DOS DISPAROS
##################################################

#checa se o tiro do invader atingiu o jogador ou chegou ao fim
collisionsBulletInvaders:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t0, bulletInvader
	addi $t0, $t0, 128
	#comparar se finalizou o disparo
	bge $t0, 0x10008F80, endBulletInvader  #31 x 31 x 4 = 0x10008F80
	lw $t2, 0($t0)
	lw $t1, aircraftColor
	lw $t3, bulletColor
	lw $t4, invaderColor
	#comparar se acertor o jogador
	beq $t2, $t4, returnCollisionsBulletInvaders
	beq $t2, $t1, changeColorAir
	beq $t2, $t3, endBulletInvader #verificar se disparo se chocaram
	
returnCollisionsBulletInvaders:
	lw $ra, 0($sp)
	add $sp, $sp, 4
	jr $ra
	
	
#checa se o tiro do jogador atingiu um invader ou chegou ao fim
collisionsBulletAir:
	add $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t0, bulletAir
	subi $t0, $t0, 128
	#comparar se finalizou o disparo
	ble $t0, 0x1000807C, endBulletAir  #x = 0
	lw $t2, 0($t0)
	lw $t3, bulletInvaderColor
	lw $t4, invaderColor
	#comparar se acertor o invader
	#############AJUSTAR AQUI############
	beq $t2, $t4, deadInvader
	beq $t2, $t3, endBulletAir #verificar se disparo se chocaram
	
returnCollisionsBulletAir:
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
	
	jr $ra	



gameOver:
	#limpar toda a tela	

