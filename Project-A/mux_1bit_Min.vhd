library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use IEEE.numeric_std.all;


entity mux_1bit_Min is
	--M is number of inputs (power of 2), A is address size (2^A must be = M)
  generic(M : integer := 32; A : integer := 5);
  port(i_C  : in std_logic_vector(A - 1 downto 0);
  		--When declaring, M is the input port, N is the bit of that input port
       i_X 	: in std_logic_vector(M-1 downto 0);
       o_M 	: out std_logic);

end mux_1bit_Min;

architecture structure of mux_1bit_Min is
  
begin
	--Selects which array to send to the output based on the integer value of the binary vector i_C
  	o_M <=	i_X(TO_INTEGER(unsigned(i_C)));
end structure;
