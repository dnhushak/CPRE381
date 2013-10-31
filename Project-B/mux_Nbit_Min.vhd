library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use IEEE.numeric_std.all;


entity mux_Nbit_Min is
  --N is I/O width, M is number of inputs (power of 2), A is address size (2^A must be = M)
  generic(N : integer := 32; M : integer := 32; A : integer := 5);
  port(i_C  : in std_logic_vector(A - 1 downto 0);
  		--When declaring, M is the input port, N is the bit of that input port
       i_X 	: in array_Nbit(M-1 downto 0, N-1 downto 0);
       o_M 	: out std_logic_vector(N-1 downto 0));

end mux_Nbit_Min;

architecture structure of mux_Nbit_Min is
  
begin
	--Selects which array to send to the output based on the integer value of the binary vector i_C
 	gen_outports: for I in 0 to N -1 generate
  		o_M(I) <=	i_X(TO_INTEGER(unsigned(i_C)),(I));
  	end generate gen_outports;
  
end structure;
