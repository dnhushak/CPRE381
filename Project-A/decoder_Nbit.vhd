
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity decoder_Nbit is
	--N determines number of input bits to decoder (address size); output will be 2 ^ A
	generic (N : integer := 2);
	port(i_A	:	in std_logic_vector;
		o_R		:	out std_logic_vector);

end decoder_Nbit;

architecture structure of decoder_Nbit is

begin
		--Checks for equality between output port number and integer value of input address
		gen_outputs: for I in 0 to 2 ** N -1 generate
			o_R(I) <= to_std_logic(I = to_integer(unsigned(i_A)));
		end generate gen_outputs;
		

		
end structure;


