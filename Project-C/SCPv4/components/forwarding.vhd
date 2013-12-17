-- fowarding.vhd
-- An implentation of a fowarding unit for the MIPS processor
-- Robert Larsen

library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;
use work.cpurecordsv4.all;

entity fowarding is
	port(MEMWB_out : in  m32_MEMWB;
		 EXMEM_out : in  m32_EXMEM;
		 IDEX_out  : in  m32_IDEX;
		 Foward_A  : out m32_2bits;
		 Foward_B  : out m32_2bits);
end fowarding;

architecture structure of fowarding is
begin
	Foward_A <= "10" when (EXMEM_out.control.reg_write = '1') and ((EXMEM_out.Rd = IDEX_out.Rs and EXMEM_out.inst(31 downto 26) = "000000") or (EXMEM_out.Rt = IDEX_out.Rs and EXMEM_out.inst(31 downto 26) /= "000000")) else 
				"01" when (MEMWB_out.control.reg_write = '1') and (EXMEM_out.control.reg_write /= '1') and ((MEMWB_out.Rd = IDEX_out.Rs and MEMWB_out.inst(31 downto 26) = "000000") or (MEMWB_out.Rt = IDEX_out.Rs and MEMWB_out.inst(31 downto 26) /= "000000")) else
				"00";
	Foward_B <= "10" when (IDEX_out.inst(31 downto 26) /="000000" and EXMEM_out.control.reg_write = '1') and ((EXMEM_out.Rd = IDEX_out.Rt and EXMEM_out.inst(31 downto 26) = "000000") or (EXMEM_out.Rt = IDEX_out.Rt and EXMEM_out.inst(31 downto 26) /= "000000")) else 
				"01" when (IDEX_out.inst(31 downto 26) /="000000" and  MEMWB_out.control.reg_write = '1') and (EXMEM_out.control.reg_write /= '1') and ((MEMWB_out.Rd = IDEX_out.Rt and MEMWB_out.inst(31 downto 26) = "000000") or (MEMWB_out.Rt = IDEX_out.Rt and MEMWB_out.inst(31 downto 26) /= "000000")) else
				"00";
	

end structure;
