library IEEE;
use IEEE.std_logic_1164.all;

entity addersubtractor_Nbit is
	generic(N : integer := 2);
	port(i_A   : in  std_logic_vector(N - 1 downto 0);
		 i_B   : in  std_logic_vector(N - 1 downto 0);
		 c_Sub : in  std_logic;
		 o_D   : out std_logic_vector(N - 1 downto 0);
		 o_C   : out std_logic);

end addersubtractor_Nbit;

architecture structure of addersubtractor_Nbit is
	component fulladder_Nbit
		generic(N : integer := N);
		port(i_A : in  std_logic_vector(N - 1 downto 0);
			 i_B : in  std_logic_vector(N - 1 downto 0);
			 i_C : in  std_logic;
			 o_D : out std_logic_vector(N - 1 downto 0);
			 o_C : out std_logic);
	end component;

	component mux_Nbit_2in
		generic(N : integer := N);
		port(c_S : in  std_logic;
			 i_A : in  std_logic_vector(N - 1 downto 0);
			 i_B : in  std_logic_vector(N - 1 downto 0);
			 o_D : out std_logic_vector(N - 1 downto 0));
	end component;

	component onescomplementer_Nbit
		generic(N : integer := N);
		port(i_A : in  std_logic_vector(N - 1 downto 0);
			 o_D : out std_logic_vector(N - 1 downto 0));

	end component;

	-- Signals
	signal s_complemented, s_muxed : std_logic_vector(N - 1 downto 0);

begin

	-- Ones complement the B input to prepare for subtraction
	OneComp : onescomplementer_Nbit
		port map(i_A => i_B,
			     o_D => s_complemented);

	-- Switch between normal or 1's complemented B input
	Mux : mux_Nbit_2in
		port map(c_S => c_Sub,
			     i_A => i_B,
			     i_B => s_complemented,
			     o_D => s_muxed);

	-- Using same select signal as the Mux for the carry in of the adder, 
	-- the 1's complement becomes 2's complement, and addition becomes
	-- subtraction without any extra gates
	FullAdder : fulladder_Nbit
		port map(i_A => i_A,
			     i_B => s_muxed,
			     i_C => c_Sub,
			     o_D => o_D,
			     o_C => o_C);

end structure;
