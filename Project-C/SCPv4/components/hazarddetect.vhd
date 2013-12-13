-- hazarddetect.vhd
-- An implentation of a hazard detection unit for the MIPS pipelined processor
-- Robert Larsen

library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;

entity hazarddetect is
	port(	ID_EX_MemRead	:	in m32_1bit,
			ID_EX_Reg_Rt	:	in m32_word,
			IF_ID_Reg_Rs	:	in m32_word,
			IF_ID_Reg_Rt	:	in m32_word,
			controlMux		:	out something....,
			IF_ID_Write		:	out something,
			PC_Write		:	out something);
end hazarddetect;

architecture structure of hazarddetect is

begin
	
end structure;