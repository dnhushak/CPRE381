library IEEE;
use IEEE.std_logic_1164.all;
use work.arr_32.all;
use IEEE.numeric_std.all;


entity n32bitmux32to1 is

  generic(N : integer := 32);
  port(i_C      : in std_logic_vector(4 downto 0);
       i_X 	: in array32_bit(N-1 downto 0);
       o_M 	: out std_logic_vector(N-1 downto 0));

end n32bitmux32to1;

architecture structure of n32bitmux32to1 is
  
begin
	--Selects which array to send to the output based on the integer value of the binary vector i_C
  --o_M <=	i_X(TO_INTEGER(unsigned(i_C)));
  o_M <= i_X(0) when i_C = "00000" ELSE
		i_X(1) when i_C = "00001" ELSE
		i_X(2) when i_C = "00010" ELSE
		i_X(3) when i_C = "00011" ELSE
		i_X(4) when i_C = "00100" ELSE
		i_X(5) when i_C = "00101" ELSE
		i_X(6) when i_C = "00110" ELSE
		i_X(7) when i_C = "00111" ELSE
		i_X(8) when i_C = "01000" ELSE
		i_X(9) when i_C = "01001" ELSE
		i_X(10) when i_C = "01010" ELSE
		i_X(11) when i_C = "01011" ELSE
		i_X(12) when i_C = "01100" ELSE
		i_X(13) when i_C = "01101" ELSE
		i_X(14) when i_C = "01110" ELSE
		i_X(15) when i_C = "01111" ELSE
		i_X(16) when i_C = "10000" ELSE
		i_X(17) when i_C = "10001" ELSE
		i_X(18) when i_C = "10010" ELSE
		i_X(19) when i_C = "10011" ELSE
		i_X(20) when i_C = "10100" ELSE
		i_X(21) when i_C = "10101" ELSE
		i_X(22) when i_C = "10110" ELSE
		i_X(23) when i_C = "10111" ELSE
		i_X(24) when i_C = "11000" ELSE
		i_X(25) when i_C = "11001" ELSE
		i_X(26) when i_C = "11010" ELSE
		i_X(27) when i_C = "11011" ELSE
		i_X(28) when i_C = "11100" ELSE
		i_X(29) when i_C = "11101" ELSE
		i_X(30) when i_C = "11110" ELSE
		i_X(31) when i_C = "11111";


   
  
end structure;
