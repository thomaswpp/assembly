.macro sleep (%milisegundos)
	li $v0 32 		# Syscall 32. Usa el Sleep de Java
	move $a0 %milisegundos
	syscall
.end_macro

.macro random_int (%hasta)
	li $v0 42 		# Random de java
	li $a0 0
	move $a1 %hasta
	syscall
.end_macro