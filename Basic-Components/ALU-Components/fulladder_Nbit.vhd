library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder_Nbit is
	generic(N : integer := 2);
	port(i_A : in  std_logic_vector(N - 1 downto 0);
		 i_B : in  std_logic_vector(N - 1 downto 0);
		 i_C : in  std_logic;
		 o_D : out std_logic_vector(N - 1 downto 0);
		 o_C : out std_logic);

end fulladder_Nbit;

architecture structure of fulladder_Nbit is
	component fulladder_1bit
		port(i_A : in  std_logic;
			 i_B : in  std_logic;
			 i_C : in  std_logic;
			 o_D : out std_logic;
			 o_C : out std_logic);
	end component;

	-- Signals - note carry is one larger than input width, to allow for cin and cout
	signal s_Carry : std_logic_vector(N downto 0);

begin
	-- Connecting the carry in to the first value of the carry signal
	s_Carry(0) <= i_C;

	-- Connect the carry out to the last value of carry signal
	o_C <= s_Carry(N);

	-- Generate the series of 1 bit adders
	g_adders : for I in 0 to N - 1 generate
		FullAdd : fulladder_1bit
			port map(i_A => i_A(I),
				     i_B => i_B(I),
				     i_C => s_Carry(I),
				     o_D => o_D(I),
				     o_C => s_Carry(I + 1));
	end generate g_adders;

end structure;
