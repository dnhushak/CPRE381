library IEEE;
use IEEE.std_logic_1164.all;

entity or_Nin is
	generic(N : integer := 32);
	port(i_A : in  std_logic_vector(N - 1 downto 0);
		 o_D : out std_logic);

end or_Nin;

architecture structure of or_Nin is
	signal s_Or : std_logic_vector(N - 3 downto 0);

begin
	-- First two inputs
	s_Or(0) <= i_A(0) or i_A(1);

	-- Cascading OR's up to last input
	g_Or : for I in 1 to N - 3 generate
		s_Or(I) <= s_Or(I - 1) or i_A(I + 1);
	end generate g_Or;

	-- Final output
	o_D <= s_Or(N - 3);

end structure;
