-- alucontrol.vhd: Implementation of ALU control for single cycle processor
-- Robert Larsen
-- November 2013

library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;

entity alucontrolv3 is
	port(i_op      : in  m32_3bits;     -- ALUop out of control
		 i_funct   : in  m32_6bits;     -- Bits 0-5 of the instruction word
		 o_jr      : out m32_1bit;      -- JR Control signal (Has to be handled here because JR is an R type instruction
		 o_shift   : out m32_1bit;      --select input A to be shamt
		 o_alucont : out m32_vector(6 downto 0)); -- Output that determines ALU operation
end alucontrolv3;

architecture structure of alucontrolv3 is
begin
	--Handle JR and JALR
	o_jr <= '1' when ((i_op & i_funct) = "000001000" or (i_op & i_funct) = "000001001")
		else '0';

	--Handle SLL, SRL, and SRA
	o_shift <= '1' when ((i_op & i_funct) = "000000000" or (i_op & i_funct) = "000000010" or (i_op & i_funct) = "000000011")
		else '0';

	-- Op Code:
	-- SHIFT SHIFT MUX AINV BINV MUX MUX 
	o_alucont <= "0000010" when (i_op) = "001" --add
		else "0000110" when (i_op) = "010" -- sub
		else "0000111" when (i_op) = "011" -- slt
		else "0000000" when (i_op) = "100" -- and
		else "0000001" when (i_op) = "101" -- or
		else "0010000" when (i_op) = "110" -- xor
		else "1111111" when (i_op) = "111"
		else "0000010" when (i_op & i_funct) = "000100000" -- add
		else "0000010" when (i_op & i_funct) = "000001000" -- jr
		else "0000010" when (i_op & i_funct) = "000001001" -- jlr
		else "0000110" when (i_op & i_funct) = "000100010" -- sub
		else "0000000" when (i_op & i_funct) = "000100100" -- and
		else "0000001" when (i_op & i_funct) = "000100101" -- or
		else "0000111" when (i_op & i_funct) = "000101010" -- slt
		else "0110100" when (i_op & i_funct) = "000000000" -- sll
		else "1010100" when (i_op & i_funct) = "000000010" -- srl
		else "1110100" when (i_op & i_funct) = "000000011" -- sra
		else "0110100" when (i_op & i_funct) = "000000100" -- sllv
		else "1010100" when (i_op & i_funct) = "000000110" -- srlv
		else "1110100" when (i_op & i_funct) = "000000111" -- srav
		else "1111111";

end structure;
