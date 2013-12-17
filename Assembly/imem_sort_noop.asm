addi $a0, $zero 0
addi $a1, $zero 8
addi $sp, $sp, -20
nop
nop
nop
sw $ra, 16( $sp )
sw $s3, 12( $sp )
sw $s2, 8 ( $sp )
sw $s1, 4 ( $sp )
sw $s0, 0 ( $sp )
addi $s2, $a0, 0
addi $s3, $a1, 0
addi $s0, $zero, 0
for1tst:
nop
nop
nop
slt $t0, $s0, $s3
nop
nop
nop
beq $t0, $zero, exit1
addi $s1, $s0, -1
for2tst:
nop
nop
nop
slt $t0, $s1, $zero
nop
nop
nop
bne $t0, $zero, exit2
sll $t1, $s1, 2
nop
nop
nop
add $t2, $s2, $t1
nop
nop
nop
lw $t3, 0($t2)
lw $t4, 4($t2)
nop
nop
nop
slt $t0, $t4, $t3
nop
nop
nop
beq $t0, $zero, exit2
addi $a0, $s2, 0
addi $a1, $s1, 0
jal swap
nop
nop
addi $s1, $s1, -1
nop
j for2tst
exit2:
nop
nop
nop
addi $s0, $s0, 1
j for1tst  
nop     
exit1:
nop
nop
nop
lw $s0, 0 ( $sp )
lw $s1, 4 ( $sp )
lw $s2, 8 ( $sp ) 
lw $s3, 12( $sp ) 
lw $ra, 16( $sp ) 
addi $sp, $sp, 20 
j end
swap:
nop
nop
nop
sll $t1, $a1, 2 
nop
nop
nop
add $t1, $a0, $t1 
nop
nop
nop
lw $t0, 0( $t1 ) 
lw $t2, 4( $t1 ) 
nop
nop
nop
sw $t2, 0( $t1 ) 
sw $t0, 4( $t1 ) 
jr $ra
end:
