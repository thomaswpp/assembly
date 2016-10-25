.data
frameBuffer:
.space 0x80000
.text

li $a0,216
li $a1,60
li $a2,112
li $a3,50
jal rectangle
li $v0,10
syscall

rectangle:
beq $a1,$zero,rectangleReturn
beq $a3,$zero,rectangleReturn

li $t0,-1
la $t1,frameBuffer
add $a1,$a1,$a0
add $a3,$a3,$a2
sll $a0,$a0,2 
sll $a1,$a1,2
sll $a2,$a2,11
sll $a3,$a3,11
addu $t2,$a2,$t1 
addu $a3,$a3,$t1
addu $a2,$t2,$a0 
addu $a3,$a3,$a0
addu $t2,$t2,$a1
li $t4,0x800

rectangleYloop:
move $t3,$a2 # pointer to current pixel for X loop; start at left edge

rectangleXloop:
sw $t0,($t3)
addiu $t3,$t3,4
bne $t3,$t2,rectangleXloop # keep going if not past the right edge of the rectangle

addu $a2,$a2,$t4 # advace one row worth for the left edge
addu $t2,$t2,$t4 # and right edge pointers
bne $a2,$a3,rectangleYloop # keep going if not off the bottom of the rectangle

rectangleReturn:
jr $ra