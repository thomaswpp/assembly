#http://textuploader.com/5nht7
	.text
main:		addi	$a0,	$0,	0x00000000		#	Colora fundo
		addiu	$a1,	$0,	1
		jal	cor_fundo
		
		la	$a0,	str				#	Endereco string a mostrar		arg0
		addi	$a1,	$0,	4			# 	Posicao Y no ecra			arg1
		addi	$a2,	$0,	8			#	Posicao X no ecra			arg2
		addi	$a3,	$0,	0x00E8E2E2		#	Cor em RGB para preencher os pixeis	arg3
		addi	$sp,	$sp,	-4			
		addi	$t2,	$0,	0x00000000
		sw	$t2,	0($sp)
		jal	print_str
		addi	$sp,	$sp,	4
		
		la	$a0,	str4				#	Endereco string a mostrar		arg0
		addi	$a1,	$0,	50			# 	Posicao Y no ecra			arg1
		addi	$a2,	$0,	30			#	Posicao X no ecra			arg2
		addi	$a3,	$0,	0x00E8E2E2		#	Cor em RGB para preencher os pixeis	arg3
		addi	$sp,	$sp,	-4			
		addi	$t2,	$0,	0x00000000
		sw	$t2,	0($sp)
		jal	print_str
		addi	$sp,	$sp,	4
		
		
		li $v0, 32					#	Delay de 3s
		li $a0, 5000
		syscall
		
		addi	$a0,	$0,	0x00333333		#	Colora fundo
		addiu	$a1,	$0,	0
		jal	cor_fundo
		
		la	$a0,	str2				#	Endereco string a mostrar		arg0
		addi	$a1,	$0,	25			# 	Posicao Y no ecra			arg1
		addi	$a2,	$0,	8			#	Posicao X no ecra			arg2
		addiu	$a3,	$0,	0x00FFFFFF		#	Cor em RGB para preencher os pixeis	arg3
		addi	$sp,	$sp,	-4			
		addi	$t2,	$0,	0x00333333
		sw	$t2,	0($sp)
		jal	print_str
		addi	$sp,	$sp,	4
		
		
		la	$a0,	str2		#  carrega endereco da string para argumento
		li	$v0,	4		#  print_string
		syscall	
		
		
		la	$a0,	entrada
		li	$a1,	100
		li	$v0,	8		#  read_string		-> $a0 ponteiro | $a1	number of chars
		syscall	
		
		la	$a0,	entrada				#	Endereco string a mostrar		arg0
		addi	$a1,	$0,	25			# 	Posicao Y no ecra			arg1
		addi	$a2,	$0,	120			#	Posicao X no ecra			arg2
		addi	$a3,	$0,	0x0033bb33		#	Cor em RGB para preencher os pixeis	arg3
		addi	$sp,	$sp,	-4			
		addi	$t2,	$0,	0x00225522
		sw	$t2,	0($sp)
		jal	print_str
		addi	$sp,	$sp,	4
		
		jal	vis_fnd
		
		
				
		la	$a0,	entrada				#	Endereco string a mostrar		arg0
		addi	$a1,	$0,	25			# 	Posicao Y no ecra			arg1
		addi	$a2,	$0,	120			#	Posicao X no ecra			arg2
		addi	$a3,	$0,	0x00ee1111		#	Cor em RGB para preencher os pixeis	arg3
		addi	$sp,	$sp,	-4			
		addi	$t2,	$0,	0x00552222
		sw	$t2,	0($sp)
		jal	print_str
		addi	$sp,	$sp,	4	
				
		la	$a0,	str3				#	Endereco string a mostrar		arg0
		addi	$a1,	$0,	45			# 	Posicao Y no ecra			arg1
		addi	$a2,	$0,	4			#	Posicao X no ecra			arg2
		addi	$a3,	$0,	0x00886666		#	Cor em RGB para preencher os pixeis	arg3
		addi	$sp,	$sp,	-4			
		addi	$t2,	$0,	0x00000000
		sw	$t2,	0($sp)
		jal	print_str
		addi	$sp,	$sp,	4
		
		j	sair
		
vis_fnd:	addi	$t0,	$0,	0x10040800		#	ponteiro para ecra[][]	
		addi	$t1,	$0,	0x00ff0000
		addi	$t2,	$0,	255						#	MAX	
loop_vis:	sw	$t1,	0($t0)
		sw	$t1,	1024($t0)
		sw	$t1,	2048($t0)
		addi	$t0,	$t0, 	4
		addi	$t2,	$t2,	-1
		
		
		sltu	$t3,	$0,	$t2
		bne	$t3,	$0,	loop_vis
		
		jr	$ra
		
		
		
cor_fundo:	addi	$t0,	$0,	0x10040000		#	ponteiro para ecra[][]			
		addi	$t1,	$0,	0x20000
loop_cor:	beq	$t1,	$0,	cor_ret
		sw	$a0,	0($t0)
		addi	$t1,	$t1,	-4
		addi	$t0,	$t0,	4
		
		beq	$a1,	$0,	loop_cor
		addi	$a0,	$a0,	1
		j	loop_cor
		
cor_ret:	jr	$ra
		
		
print_str:	addi	$t0,	$0,	0x10040000		#	ponteiro para ecra[][]			
		addi	$sp,	$sp,	-8			#	Adiciona espaco na pilha
		sw	$a2,	4($sp)
		sw 	$ra,	0($sp)				#	Guarda endereco de retorno na pilha
		la	$t1,	asci				#	Base para tab com matriz de pontos

prox_char:	slti	$t2,	$a2,	250			#	Verifica se h� espa�o para escrever o caracter
		bne	$t2,	$0,	segue			#	na linh atual. Se h�, segue,
new_line:	lw	$t2,	4($sp)				#	se nao, muda de linha,
		add	$a2,	$0,	$t2			# 	come�ando no X pedido em print_str
		addi	$a1,	$a1,	10

segue:		lbu	$t2,	0($a0)				#	t2	guarda valor char[i]
		beq	$t2,	$0,	fim_str			#	Se char == '\0' -> fim da string
		
		addi	$t3,	$0,	9
		beq	$t3,	$t2,	tabulacao
		
		addiu	$t3,	$0,	10			#	� uma quebra de linha?
		bne	$t3,	$t2,	chama			#	Se nao salta para chama
		
		lw	$t2,	4($sp)				#	Muda de linha,
		add	$a2,	$0,	$t2			# 	come�ando no X pedido em print_str
		addi	$a1,	$a1,	10
		
chama:		jal	print_char				#	Chama subrotina que imprime char a char.
		
regresso:			
								#	Volta para aqui | 
		addi	$a0,	$a0,	1			#	Endere�o do proximo char na string
		
		j	prox_char				#	Salta para verificar se h� proximo char
		
	
fim_str:	lw	$ra,	0($sp)				#	Recupera endere�o de retorno
		addi	$sp,	$sp,	4			# 	liberta espa�o ocupado na pilha
		jr	$ra					#	volta para onde foi chamado
		
		
		#	print_char	� a subrotina que imprime o char
print_char:	add	$t7,	$0,	$0			#	contador de 4 x 4
		add	$t6,	$0,	$0			#	contador de 8 x 4
		sll	$t2,	$t2,	2			#	Multiplica 4 por t2 e guarda em t2 (indice)
		add	$t2,	$t2,	$t1			#	T2 � endere�o da matriz para char
		lw	$t5,	($t2)				# 	carrega a matriz do char para t5
		beq	$t5,	$0,	espaco			#	Se t5 � 0, � porque � um espaco
							
		sll	$t4,	$a2,	2			#	Distancia X � origem (ecra)
		sll	$t3,	$a1,	10			#	Distancia Y � origem (ecra)
		add	$t4,	$t4,	$t3			#	Distancia � origem XY
		add	$t4,	$t0,	$t4			#	Endere�o mem para pixel

pixel:		andi	$t3,	$t5,	0x01			#	Mascara bit menos signf (� o bit <-> pixel)
		beq	$t3,	$0,	zero			#	S� imprime pixel se for 1. Se for 0 passa
		sw	$a3,	0($t4)				# 	Mete o pixel condiserado da cor escolhida
		j	passa
		
zero:		lw	$t3	8($sp)
		beq	$t3,	$0,	passa		
		sw	$t3,	0($t4)	
		j	passa

passa:		addiu	$t4,	$t4,	4			#	Endere�o proximo pixel ecra
		srl	$t5,	$t5,	1			#	Proximo ponto na matriz do char
		
		addiu	$t7,	$t7,	4			#	Incrementa contador de X
		
		slti	$t3,	$t7,	0xf			#	Passou o limite lateral? ( ie, 4px )
		beq	$t3,	$zero,	muda_linha		#	Se sim, muda de linha
		j	pixel					#	Se n�o, imprime o proximo pixel

espaco:		lw	$t3,	4($sp)				#	S� imprime espa�o util
		beq	$t3,	$a2,	fim_char		#	Nao imprime espaco na primeira coluna
				
		j	espaco_5px				

muda_linha:	add	$t7,	$0,	$0			#	deltaX volta a 0
		addiu	$t6,	$t6,	0x0400			#	deltaY	vai para linha de baixo
		addiu	$t4,	$t4	0x0400			#	Endere�o proximo px muda de linha
		addi	$t4,	$t4,	-16			#	Volta ao pixel incial da matriz do caracter
		
		slti	$t3,	$t6,	0x2000			#	Chagou � ultima linha?
		bne	$t3,	$zero,	pixel			#	Se n�o, imprime proximo pixel
		
espaco_5px:	addi	$a2,	$a2, 	5			#	Avan�a 5 px no acra.
		
fim_char:	jr	$ra					#	Acabou a impressao do char. Volta para print_string

tabulacao:	addi	$a2,	$a2, 	12
		jr	$ra

sair:		

	#	Strings a usar e matrizes de pontos dos caracteres da tab ASCII para mostar
	#		no ecra bitmap
		
		.data
	str:	.asciiz		"Demonstracao de impressao de caracteres em bitmap usando matrizes de pontos no MARS."
	str2:	.asciiz		"Escreva o seu nome:\n"
	str3:	.asciiz		"1) Loitering And Prowling At Night\n2) Criminal Attempt-Theft by Unlawful\n\tTaking-Moveable Property\n3) Possessing Instruments of Crime\n4) Criminal Conspiracy to Loiter and Prowl At\n\tNight, Theft by Unlawful Taking, Possess\n\tInstruments of Crime"
	str4:	.asciiz		"Nelson Ferreira.. Assembly MIPS 2016\n\t\tFCT UC PT"
	entrada:.space		100
	asci:	.word		0,	0,	0,	0,	0,	0,	0,	0,	#	ASCII
				0,	0,	0,	0,	0,	0,	0,	0,	# SYSTEM CHARs
				0,	0,	0,	0,	0,	0,	0,	0,	
				0,	0,	0,	0,	0,	0,	0,	0,	
				0x00000000,	0x06066666,	0x000000AA,	0x0AAFAFAA,	# Caracteres visiveis
				0x26BA6D64,	0xCC124833,	0x69952666,	0x00000044,
				0x63333336,	0x6CCCCCC6,	0x00096690,	0x00027200,
				0x12200000,	0x0000F000,	0x06600000,	0x11224488,
				0x069BD960,	0x04444640,	0x0F248960,	0x0698C960,
				0x08F92480,	0x069871F0,	0x06997160,	0x022448F0,
				0x06996960,	0x078E9960,	0x03303300,	0x13303300,
				0x00C636C0,	0x000F0F00,	0x0036C630,	0x60648996,
				0x695B7F96,	0x0999F996,	0x07997997,	0x06911196,	# @, A, B, C
				0x07999997,	0x0F11711F,	0x0111711F,	0x0699D196,
				0x0999F999,	0x07222227,	0x0254444E,	0x09953359,
				0x0F111111,	0x099999F9,	0x099DDBB9,	0x06999996,
				0x01117997,	0x86D99996,	0x09997997,	0x06986196,
				0x0222222F,	0x06999999,	0x06669999,	0x09FF9999,
				0x09966699,	0x0124E999,	0x0F12448F,	0xF333333F,
				0x88442211,	0xFCCCCCCF,	0x00000052,	0xF0000000,
				0x00000042,	0x0E9E8600,	0x07997110,	0x0E111E00,	#  `,a, b, c
				0x0E999E88,	0x061F9600,	0x12272400,	0x68E99E00,
				0x09997111,	0x06222020,	0x12223020,	0x09953590,
				0x02222222,	0x0999F900,	0x09999700,	0x06999600,
				0x11799700,	0x88E99E00,	0x02222600,	0x06861600,
				0x04222720,	0x0E999900,	0x06699900,	0x09FF9900,
				0x0956A900,	0x02469900,	0x0F124F00,	0x42221224,
				0x44444444,	0x24448442,	0x0000007A,	0x0FDDDDDF	# 32 -127
