-- fowarding.vhd
-- An implentation of a fowarding unit for the MIPS processor
-- Robert Larsen

library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;

entity fowarding is
	port(	MEM_WB_RegWrite	:	in m32_1bit;
			MEM_WB_RegRd	:	in m32_word;
			EX_MEM_RegWrite	:	in m32_1bit;
			EX_MEM_RegRd	:	in m32_word;
			ID_EX_RegRs		:	in m32_word;
			ID_EX_RegRt		:	in m32_word;
			Foward_A		:	out m32_2bits;
			Foward_B		:	out m32_2bits);
end fowarding;

architecture structure of fowarding is

begin

	Foward_A <= "10" when (EX_MEM_RegWrite = '1') and (EX_MEM_RegRd /= "00000000000000000000000000000000") and (EX_MEM_RegRd = ID_EX_RegRs) else
				"01" when (MEM_WB_RegWrite = '1') and (MEM_WB_RegRd /= "00000000000000000000000000000000") and not((EX_MEM_RegWrite = '1') and (EX_MEM_RegRd /= "00000000000000000000000000000000") and (EX_MEM_RegRd = ID_EX_RegRs)) and (MEM_WB_RegRd = ID_EX_RegRs) else
				"00";
				
	Foward_B <= "10" when (EX_MEM_RegWrite = '1') and (EX_MEM_RegRd /= "00000000000000000000000000000000") and (EX_MEM_RegRd = ID_EX_RegRt) else
				"01" when (MEM_WB_RegWrite = '1') and (MEM_WB_RegRd /= "00000000000000000000000000000000") and not((EX_MEM_RegWrite = '1') and (EX_MEM_RegRd /= "00000000000000000000000000000000") and (EX_MEM_RegRd = ID_EX_RegRt)) and (MEM_WB_RegRd = ID_EX_RegRt) else
				"00";
	
end structure;
