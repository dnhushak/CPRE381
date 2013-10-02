library IEEE;
use IEEE.std_logic_1164.all;
use work.arr_32.all;
use IEEE.numeric_std.all;


entity n32bitmux32to1 is

  generic(N : integer := 2);
  port(i_C      : in std_logic_vector(4 downto 0);
       i_X 		: in array32_bit(N-1 downto 0);
       o_M 		: out std_logic_vector(N-1 downto 0));

end n32bitmux32to1;

architecture structure of n32bitmux32to1 is
  
begin
	--Selects which array to send to the output based on the integer value of the binary vector i_C
  o_M <=	i_X(TO_INTEGER(unsigned(i_C)));

   
  
end structure;
