start:lui $t1, 15
addi $t6,$zero, -10
addi $t2,$zero, 1
addi $t4, $zero, 15
nop
nop 
nop
nop
ori $s0, $t1, 15
andi $s0, $t4, 2
srl $s0, $t1, 2
slti $s0, $t4, 30
slti $s0, $t4, 10
sra $s0, $t1, 2
sra $s0, $t6, 2
xor $s0, $t1, $t6
sllv $s0, $t4, $t2
srlv $s0, $t1, $t2
srav $s0, $t6, $t2