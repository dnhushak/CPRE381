library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use IEEE.numeric_std.all;

entity mux_Nbit_Min is
	--N is I/O width, M is number of inputs (power of 2), A is address size (2^A must be = M)
	generic(N : integer := 32;
		    M : integer := 32;
		    A : integer := 5);
	port(c_S : in  std_logic_vector(A - 1 downto 0);
		 --When declaring, M is the input port, N is the bit of that input port
		 i_A : in  array_Nbit(M - 1 downto 0, N - 1 downto 0);
		 o_D : out std_logic_vector(N - 1 downto 0));

end mux_Nbit_Min;

architecture structure of mux_Nbit_Min is
begin
	--Selects which array to send to the output based on the integer value of the binary vector c_S
	g_Outputs : for I in 0 to N - 1 generate
		o_D(I) <= i_A(TO_INTEGER(unsigned(c_S)), (I));
	end generate g_Outputs;

end structure;
