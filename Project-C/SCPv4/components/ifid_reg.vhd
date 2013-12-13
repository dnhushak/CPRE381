-- ifid_reg.vhd: The IFID register
--
-- Zhao Zhang, CprE 381, fall 2013
--

library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;
use work.cpurecordsv4.all;

entity IFID_reg is
	port(D     : in  m32_IFID;          -- Input from IF stage
		 Q     : out m32_IFID;          -- Output to ID stage
		 WE    : in  m32_1bit;          -- Write enable
		 reset : in  m32_1bit;          -- The reset/flush signal
		 clock : in  m32_1bit);         -- The clock signal
end IFID_reg;

architecture behavior of IFID_reg is
begin
	REG : process(clock)
	begin
		if (rising_edge(clock)) then
			if (reset = '1') then       -- Reset the instruction to a nop
				Q.inst <= (Q.inst'range => '0');
			elsif (WE = '1') then
				Q <= D;
			end if;
		end if;
	end process;
end behavior;
