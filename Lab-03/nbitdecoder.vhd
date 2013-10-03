
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity nbitdecoder is
	--INBITS determines number of input bits to decoder; output will be 2 ^ INBITS
	generic (INBITS : integer := 2);
	port(i_A	:	in std_logic_vector(INBITS - 1 downto 0);
		o_R		:	out std_logic_vector(2 ** INBITS - 1 downto 0));

end nbitdecoder;

architecture structure of nbitdecoder is

begin
		--Checks for equality between output port number and integer value of input address
		gen_outputs: for I in 0 to 2 ** INBITS -1 generate
			o_R(I) <= to_std_logic(I = to_integer(unsigned(i_A)));
		end generate gen_outputs;
		
end structure;


