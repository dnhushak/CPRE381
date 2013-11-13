library IEEE;
use IEEE.std_logic_1164.all;

entity mux_1bit_2in is
	port(c_S : in  std_logic;
		 i_A : in  std_logic;
		 i_B : in  std_logic;
		 o_D : out std_logic);

end mux_1bit_2in;

architecture structure of mux_1bit_2in is
	component and_2in
		port(i_A : in  std_logic;
			 i_B : in  std_logic;
			 o_D : out std_logic);
	end component;

	component or_2in
		port(i_A : in  std_logic;
			 i_B : in  std_logic;
			 o_D : out std_logic);
	end component;

	component inv_1bit
		port(i_A : in  std_logic;
			 o_D : out std_logic);
	end component;

	signal s_Sinv, s_MuxA, s_MuxB : std_logic;

begin

	--IF C == 0, THEN X, C == 1, THEN Y

	---------------------------------------------------------------------------
	-- Level 1: invert Control Signal
	---------------------------------------------------------------------------
	invertC : inv_1bit
		port map(i_A => c_S,
			     o_D => s_Sinv);

	---------------------------------------------------------------------------
	-- Level 2: AND A and B with the control signal (or inverted control signal)
	---------------------------------------------------------------------------
	MuxA : and_2in
		port map(i_A => i_A,
			     i_B => s_Sinv,
			     o_D => s_MuxA);

	MuxB : and_2in
		port map(i_A => i_B,
			     i_B => c_S,
			     o_D => s_MuxB);

	---------------------------------------------------------------------------
	-- Level 3: OR the Mux'ed signals together
	---------------------------------------------------------------------------
	FinalOr : or_2in
		port map(i_A => s_MuxA,
			     i_B => s_MuxB,
			     o_D => o_D);

end structure;
