library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;

entity comparator_Nbit is
	generic(N : integer := 4);
	port(i_A   : in  std_logic_vector(N - 1 downto 0);
		 i_B   : in  std_logic_vector(N - 1 downto 0);
		 o_EQ  : out std_logic;
		 o_NEQ : out std_logic);
end entity comparator_Nbit;

architecture structure of comparator_Nbit is
	component xor_2in
		port(i_A : in  std_logic;
			 i_B : in  std_logic;
			 o_D : out std_logic);
	end component;

	component or_Nin
		generic(N : integer);
		port(i_A : in  std_logic_vector(N - 1 downto 0);
			 o_D : out std_logic);
	end component;

	component inv_1bit
		port(i_A : in  std_logic;
			 o_D : out std_logic);
	end component;

	signal s_xorout : std_logic_vector(N - 1 downto 0);
	signal s_NEQ    : std_logic;

begin

	-- Bitwise XOR each input
	g_xor : for I in 0 to N - 1 generate
		comparators : xor_2in
			port map(i_A => i_A(I),
				     i_B => i_B(I),
				     o_D => s_xorout(I));
	end generate g_xor;

	-- OR the outputs of all the xors, if any are 1, then Not Equal
	compare_OR : or_Nin
		generic map(N => N)
		port map(i_A => s_xorout,
			     o_D => s_NEQ);

	-- Send NEQ to output
	o_NEQ <= s_NEQ;

	-- NOT NEQ to get EQ
	make_eq : inv_1bit
		port map(i_A => s_NEQ, o_D => o_EQ);

end architecture structure;
