library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use IEEE.numeric_std.all;

entity mux_Nbit_2in is
	--N is input width
	generic(N : integer := 32);
	port(c_S : in  std_logic_vector;
		 i_A : in  std_logic_vector(N - 1 downto 0);
		 i_B : in  std_logic_vector(N - 1 downto 0);
		 o_D : out std_logic);

end mux_Nbit_2in;

architecture structure of mux_Nbit_2in is
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

	signal s_Sinv         : std_logic;
	signal s_MuxA, s_MuxB : std_logic_vector(N - 1 downto 0);

begin

	--IF C == 0, THEN X, C == 1, THEN Y

	---------------------------------------------------------------------------
	-- Level 1: invert Control Signal
	---------------------------------------------------------------------------
	invertC : inv_1bit
		port map(i_A => c_S,
			     o_D => s_Sinv);

	g_Muxes : for I in 0 to N - 1 generate
		---------------------------------------------------------------------------
		-- Level 2: AND A and B with the control signal (or inverted control signal)
		---------------------------------------------------------------------------
		MuxA : and_2in
			port map(i_A => i_A(I),
				     i_B => s_Sinv,
				     o_D => s_MuxA(I));

		MuxB : and_2in
			port map(i_A => i_B(I),
				     i_B => c_S,
				     o_D => s_MuxB(I));

		---------------------------------------------------------------------------
		-- Level 3: OR the Mux'ed signals together
		---------------------------------------------------------------------------
		FinalOr : or_2in
			port map(i_A => s_MuxA(I),
				     i_B => s_MuxB(I),
				     o_D => o_D(I));
	end generate g_Muxes;
end structure;
