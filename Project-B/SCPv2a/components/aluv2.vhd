-- ALUv2.vhd
-- 
-- The ALUv2 unit
--
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.mips32.all;

entity ALUv2 is
	port(rdata1   : in  m32_word;
		 rdata2   : in  m32_word;
		 ALU_code : in  m32_5bits;
		 result   : out m32_word;
		 zero     : out m32_1bit);
end entity;

architecture behavior of ALUv2 is
	signal r : m32_word;
begin
	P_ALUv2 : process(ALU_code, rdata1, rdata2)
		variable a, b, sum, diff, slt : integer;
	begin
		-- Pre-calculate arithmetic results
		a    := to_integer(signed(rdata1));
		b    := to_integer(signed(rdata2));
		sum  := a + b;
		diff := a - b;
		if (a < b) then
			slt := 1;
		else
			slt := 0;
		end if;

		-- Select the result, convert to signal if necessary
		case (ALU_code) is
			when "00000" =>             -- AND
				r <= rdata1 AND rdata2;
			when "00001" =>             -- OR
				r <= rdata1 OR rdata2;
			when "00010" =>             -- add
				r <= std_logic_vector(to_signed(sum, 32));
			when "00110" =>             -- subtract
				r <= std_logic_vector(to_signed(diff, 32));
			when "00111" =>             -- slt
				r <= std_logic_vector(to_unsigned(slt, 32));
			when "01100" =>             -- NOR
				r <= rdata1 NOR rdata2;
			when "10000" =>             -- XOR
				r <= rdata1 XOR rdata2;
			when "10100" =>
				r <= rdata2 sll rdata1; -- sll
			when others =>              -- Otherwise, make output to be 0
				r <= (others => '0');
		end case;
	end process;

	-- Drive the ALUv2 result output
	result <= r;

	-- Drive the zero output
	with r select zero <=
		'1' when x"00000000",
		'0' when others;
end behavior;
