library IEEE;
use IEEE.std_logic_1164.all;

entity or_Nbit is
	generic(N : integer := 2);
	port(i_A : in  std_logic_vector(N - 1 downto 0);
		 o_F : out std_logic);

end or_Nbit;

architecture dataflow of or_Nbit is
	signal s_or : std_logic_vector(N - 3 downto 0);

begin
	s_or(0) <= i_A(0) or i_A(1);
	OR_GEN : for I in 1 to N - 3 generate
		s_or(I) <= s_or(I - 1) or i_A(I + 1);
	end generate OR_GEN;
	o_F <= s_or(N - 3);

end dataflow;
