-- alucontrol.vhd: Implementation of ALU control for single cycle processor
-- Robert Larsen
-- November 2013

library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;

entity alucontrol is
	port(	i_op		:	in m32_2bits;		-- ALUop out of control
			i_funct		:	in m32_6bits;		-- Bits 0-5 of the instruction word
			o_alucont	:	out m32_4bits);		-- Output that determines ALU operation
end alucontrol;

architecture structure of alucontrol is
	
	begin
		o_alucont	<=	"0010" when (i_op) = "00" else
						"0110" when (i_op) = "01" else
						"0010" when (i_op & i_funct) = "10100000" else
						"0110" when (i_op & i_funct) = "10100010" else
						"0000" when (i_op & i_funct) = "10100100" else
						"0001" when (i_op & i_funct) = "10100101" else
						"0111" when (i_op & i_funct) = "10101010" else
						"1111";
	
end structure;
