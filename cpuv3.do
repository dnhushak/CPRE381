onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider -height 25 {Signals of Note}
add wave -noupdate -color White -format Logic -height 15 -label Clock /tb_cpuv3/clock
add wave -noupdate -color {Blue Violet} -format Literal -height 15 -label {PC Address} -radix decimal /tb_cpuv3/imem_addr
add wave -noupdate -color Magenta -format Literal -height 15 -itemcolor {Green Yellow} -label Instruction /tb_cpuv3/inst
add wave -noupdate -color Yellow -format Literal -height 15 -label {ALU Result} -radix hexadecimal /tb_cpuv3/cpu1/masteraluv2/o_d
add wave -noupdate -color Yellow -format Logic -height 15 -label {ALU OF Output} /tb_cpuv3/cpu1/masteraluv2/o_of
add wave -noupdate -color Yellow -format Logic -height 15 -label {ALU Zero Result} /tb_cpuv3/cpu1/masteraluv2/o_zero
add wave -noupdate -divider -height 25 Memory
add wave -noupdate -color Khaki -format Literal -height 15 -radix decimal /tb_cpuv3/data_mem/mem(10)
add wave -noupdate -color Khaki -format Literal -height 15 -radix decimal /tb_cpuv3/data_mem/mem(9)
add wave -noupdate -color Khaki -format Literal -height 15 -radix decimal /tb_cpuv3/data_mem/mem(8)
add wave -noupdate -color Khaki -format Literal -height 15 -radix decimal /tb_cpuv3/data_mem/mem(7)
add wave -noupdate -color Khaki -format Literal -height 15 -radix decimal /tb_cpuv3/data_mem/mem(6)
add wave -noupdate -color Khaki -format Literal -height 15 -radix decimal /tb_cpuv3/data_mem/mem(5)
add wave -noupdate -color Khaki -format Literal -height 15 -radix decimal /tb_cpuv3/data_mem/mem(4)
add wave -noupdate -color Khaki -format Literal -height 15 -radix decimal /tb_cpuv3/data_mem/mem(3)
add wave -noupdate -color Khaki -format Literal -height 15 -radix decimal /tb_cpuv3/data_mem/mem(2)
add wave -noupdate -color Khaki -format Literal -height 15 -radix decimal /tb_cpuv3/data_mem/mem(1)
add wave -noupdate -color Khaki -format Literal -height 15 -radix decimal /tb_cpuv3/data_mem/mem(0)
add wave -noupdate -divider -height 25 Registers
add wave -noupdate -color Cyan -format Literal -height 15 -label {Register Outputs} -radix hexadecimal /tb_cpuv3/cpu1/registers/s_regoutsingle
add wave -noupdate -height 15 -group {Register I/O} -format Literal -height 15 -label {Write Address} /tb_cpuv3/cpu1/registers/i_wa
add wave -noupdate -height 15 -group {Register I/O} -format Literal -height 15 -label {Write Data} -radix hexadecimal /tb_cpuv3/cpu1/registers/i_a
add wave -noupdate -height 15 -group {Register I/O} -format Literal -height 15 -label {Read 1 Address} /tb_cpuv3/cpu1/registers/i_r1a
add wave -noupdate -height 15 -group {Register I/O} -format Literal -height 15 -label {Read 1 Data} -radix hexadecimal /tb_cpuv3/cpu1/registers/o_d1o
add wave -noupdate -height 15 -group {Register I/O} -format Literal -height 15 -label {Read 2 Address} /tb_cpuv3/cpu1/registers/i_r2a
add wave -noupdate -height 15 -group {Register I/O} -format Literal -height 15 -label {Read 2 Data} -radix hexadecimal /tb_cpuv3/cpu1/registers/o_d2o
add wave -noupdate -divider -height 25 {Control Signals}
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Literal -height 15 -label {Instruction Opcode} /tb_cpuv3/cpu1/controller/op_code
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Literal -height 15 -label {ALU OpCode} /tb_cpuv3/cpu1/alucontroller/o_alucont
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Logic -height 15 -label {JR Select} /tb_cpuv3/cpu1/alucontroller/o_jr
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Logic -height 15 -label {Shift Select} /tb_cpuv3/cpu1/alucontroller/o_shift
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Logic -height 15 -label {Reg Dst} /tb_cpuv3/cpu1/controller/reg_dst
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Logic -height 15 -label {ALU Src} /tb_cpuv3/cpu1/controller/alu_src
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Logic -height 15 -label {Mem to Reg} /tb_cpuv3/cpu1/controller/mem_to_reg
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Logic -height 15 -label {Reg Write} /tb_cpuv3/cpu1/controller/reg_write
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Logic -height 15 -label {Mem Read} /tb_cpuv3/cpu1/controller/mem_read
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Logic -height 15 -label {Mem Write} /tb_cpuv3/cpu1/controller/mem_write
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Literal -height 15 -label {Branch Select} /tb_cpuv3/cpu1/controller/branch
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Literal -height 15 -label {ALU Controller Opcode} /tb_cpuv3/cpu1/controller/alu_op
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Logic -height 15 -label {Jump Select} /tb_cpuv3/cpu1/controller/jump
add wave -noupdate -height 15 -group {Control Signals} -color Orange -format Logic -height 15 -label {JAL Select} /tb_cpuv3/cpu1/controller/jal
add wave -noupdate -divider -height 25 {ALU Signals}
add wave -noupdate -height 15 -group {ALU Signals} -color Yellow -format Literal -height 15 -label {In A} -radix hexadecimal /tb_cpuv3/cpu1/masteraluv2/i_a
add wave -noupdate -height 15 -group {ALU Signals} -color Yellow -format Literal -height 15 -label {In B} -radix hexadecimal /tb_cpuv3/cpu1/masteraluv2/i_b
add wave -noupdate -height 15 -group {ALU Signals} -color Yellow -format Logic -height 15 -label Ainvert /tb_cpuv3/cpu1/masteraluv2/i_ainv
add wave -noupdate -height 15 -group {ALU Signals} -color Yellow -format Logic -height 15 -label Binvert /tb_cpuv3/cpu1/masteraluv2/i_binv
add wave -noupdate -height 15 -group {ALU Signals} -color Yellow -format Literal -height 15 -label {ALU Mux} /tb_cpuv3/cpu1/masteraluv2/c_op
add wave -noupdate -divider -height 25 Other
add wave -noupdate -color Yellow -format Logic -height 15 -label Reset /tb_cpuv3/reset
add wave -noupdate -format Literal -height 15 -label {Memory Address} -radix decimal /tb_cpuv3/cpu1/dmem_addr
add wave -noupdate -format Literal -height 15 -label {Memory Write Mask} /tb_cpuv3/cpu1/dmem_wmask
add wave -noupdate -format Literal -height 15 -label {Memory Read Data} -radix hexadecimal /tb_cpuv3/cpu1/dmem_rdata
add wave -noupdate -format Literal -height 15 -label {Memory Write Data} -radix hexadecimal /tb_cpuv3/cpu1/dmem_wdata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {891 ns} 0}
configure wave -namecolwidth 375
configure wave -valuecolwidth 345
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {977 ns} {2802 ns}
