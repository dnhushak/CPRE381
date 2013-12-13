-- hazarddetect.vhd
-- An implentation of a hazard detection unit for the MIPS pipelined processor
-- Robert Larsen

library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;
use work.cpurecordsv4.all;

entity hazarddetect is
	port(IDEX_out  : in  m32_IDEX;
		 IFID_out  : in  m32_IFID;
		 EXMEM_out : in  m32_EXMEM;
		 MEMWB_out : in  m32_MEMWB;
		 jump      : in  m32_1bit;
		 jr        : in  m32_1bit;
		 branch    : in  m32_1bit;
		 IDEX_WE   : out m32_1bit;
		 IFID_WE   : out m32_1bit;
		 EXMEM_WE  : out m32_1bit;
		 MEMWB_WE  : out m32_1bit;
		 IDEX_RST  : out m32_1bit;
		 IFID_RST  : out m32_1bit;
		 EXMEM_RST : out m32_1bit;
		 MEMWB_RST : out m32_1bit);
end hazarddetect;

architecture structure of hazarddetect is
begin
	IFID_WE  <= '1';
	IDEX_WE  <= '1';
	EXMEM_WE <= '1';
	MEMWB_WE <= '1';
	-- Bubble after a jump or branch 
	IFID_RST <= '1' when jump ='1' or jr ='1'  or branch = '1'
		else '0';
	IDEX_RST  <= '0';
	EXMEM_RST <= '0';
	MEMWB_RST <= '0';
end structure;