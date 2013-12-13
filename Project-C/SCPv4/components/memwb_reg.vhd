library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;
use work.cpurecordsv4.all;

entity MEMWB_reg is
	port(D     : in  m32_MEMWB;         -- Input from MEM stage
		 Q     : out m32_MEMWB;         -- Output to WB stage
		 WE    : in  m32_1bit;          -- Write enable
		 reset : in  m32_1bit;          -- The reset/flush signal
		 clock : in  m32_1bit);         -- The clock signal
end MEMWB_reg;

architecture behavior of MEMWB_reg is
begin
	REG : process(clock)
	begin
		if (rising_edge(clock)) then
			if (reset = '1') then
				Q.control.reg_write <= '0';
				Q.control.mem_write <= '0';
				Q.inst              <= (Q.inst'range => '0');
				Q.inst_string       <= "BUBBLE    BUBBLE    BUBBLE    ";
			elsif (WE = '1') then
				Q <= D;
			end if;
		end if;
	end process;
end behavior;