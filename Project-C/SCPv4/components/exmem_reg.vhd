library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;
use work.cpurecordsv4.all;

entity EXMEM_reg is
	port(D     : in  m32_EXMEM;         -- Input from EX stage
		 Q     : out m32_EXMEM;         -- Output to MEM stage
		 WE    : in  m32_1bit;          -- Write enable
		 reset : in  m32_1bit;          -- The reset/flush signal
		 clock : in  m32_1bit);         -- The clock signal
end EXMEM_reg;

architecture behavior of EXMEM_reg is
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