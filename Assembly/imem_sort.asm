lw $a0, 0($zero) --0
lw $a1, 4($zero) --1
addi $sp, $sp, -20 --2
sw $ra, 16( $sp ) --3
sw $s3, 12( $sp ) --4
sw $s2, 8 ( $sp ) --5
sw $s1, 4 ( $sp ) --6
sw $s0, 0 ( $sp ) --7
addi $s2, $a0, 0 --8
addi $s3, $a1, 0 --9
addi $s0, $zero, 0 --10
for1tst:
slt $t0, $s0, $s3 --11
beq $t0, $zero, exit1 --12
addi $s1, $s0, -1 --13
for2tst:
slt $t0, $s1, $zero --14
bne $t0, $zero, exit2 --15
sll $t1, $s1, 2 --16
add $t2, $s2, $t1 --17
lw $t3, 0($t2) --18
lw $t4, 4($t2) --19
slt $t0, $t4, $t3 --20
beq $t0, $zero, exit2  --21     
addi $a0, $s2, 0 --22
addi $a1, $s1, 0 --23
jal swap --24
addi $s1, $s1, -1 --25
j for2tst         --26
exit2:
addi $s0, $s0, 1 --27
j for1tst       --28
exit1:
lw $s0, 0 ( $sp ) --29
lw $s1, 4 ( $sp ) --30
lw $s2, 8 ( $sp ) --31
lw $s3, 12( $sp ) --32
lw $ra, 16( $sp ) --33
addi $sp, $sp, 20 --34
j end --35
swap:
sll $t1, $a1, 2 --36
add $t1, $a0, $t1    --37
lw $t0, 0( $t1 ) --38
lw $t2, 4( $t1 ) --39
nop
nop
sw $t2, 0( $t1 ) --40
sw $t0, 4( $t1 ) --41
jr $ra --42
end:
