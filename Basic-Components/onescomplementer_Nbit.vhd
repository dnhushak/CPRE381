library IEEE;
use IEEE.std_logic_1164.all;

entity onescomplementer_Nbit is
	generic(N : integer);
	port(i_A : in  std_logic_vector(N - 1 downto 0);
		 o_D : out std_logic_vector(N - 1 downto 0));

end onescomplementer_Nbit;

architecture structure of onescomplementer_Nbit is
	component inv_1bit
		port(i_A : in  std_logic;
			 o_D : out std_logic);
	end component;

begin
	g_inv : for I in 0 to N - 1 generate
		inverters : inv_1bit
			port map(i_A => i_A(I),
				     o_D => o_D(I));
	end generate g_inv;

end structure;
