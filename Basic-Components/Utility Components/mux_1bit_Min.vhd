library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use IEEE.numeric_std.all;

entity mux_1bit_Min is
	--M is number of inputs (power of 2), A is address size (2^A must be = M)
	generic(M : integer := 32;
		    A : integer := 5);
	port(c_S : in  std_logic_vector(A - 1 downto 0);
		 i_A : in  std_logic_vector(M - 1 downto 0);
		 o_D : out std_logic);

end mux_1bit_Min;

architecture structure of mux_1bit_Min is
begin
	--Selects which array to send to the output based on the integer value of the binary vector c_S
	o_D <= i_A(TO_INTEGER(unsigned(c_S)));
end structure;
