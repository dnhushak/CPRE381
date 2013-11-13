library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder_1bit is
	port(i_A : in  std_logic;
		 i_B : in  std_logic;
		 i_C : in  std_logic;
		 o_D : out std_logic;
		 o_C : out std_logic);

end fulladder_1bit;

architecture structure of fulladder_1bit is

	-- Describe the component entities as defined in Adder.vhd 
	-- and Multiplier.vhd (not strictly necessary).
	component and_2in
		port(i_A : in  std_logic;
			 i_B : in  std_logic;
			 o_D : out std_logic);
	end component;

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

	-- Signals
	signal s_AxorB, s_AandB, s_AandC, s_BandC : std_logic;

begin

	---------------------------------------------------------------------------
	-- Level 1: XOR A and B; AND A,B; A,C; B,C
	---------------------------------------------------------------------------
	XorAB : xor_2in
		port MAP(i_A => i_A,
			     i_B => i_B,
			     o_D => s_AxorB);

	AndAB : and_2in
		port MAP(i_A => i_A,
			     i_B => i_B,
			     o_D => s_AandB);

	AndAC : and_2in
		port MAP(i_A => i_A,
			     i_B => i_C,
			     o_D => s_AandC);

	AndBC : and_2in
		port MAP(i_A => i_B,
			     i_B => i_C,
			     o_D => s_BandC);

	---------------------------------------------------------------------------
	-- Level 2: XOR with Control signal, OR all the AND results
	---------------------------------------------------------------------------
	XorCarry : xor_2in
		port MAP(i_A => s_AxorB,
			     i_B => i_C,
			     o_D => o_D);

	OrResults : or_Nin
		generic map(N => 3)
		port MAP(i_A(0) => s_AandB,
			     i_A(1) => s_AandC,
			     i_A(2) => s_BandC,
			     o_D    => o_C);
end structure;
