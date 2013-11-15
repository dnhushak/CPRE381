library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;

entity leftshifter_Nbit is
	-- N is number of input bits (must be a power of 2)
	-- A is size of shift amount (A^2 = N)
	generic(N : integer := 32;
		    A : integer := 5);
	port(i_A     : in  std_logic_vector(N - 1 downto 0); -- input to shift
		 c_Shamt : in  std_logic_vector(A - 1 downto 0); -- amount to shift by
		 o_D     : out std_logic_vector(N - 1 downto 0)); -- shifted output

end leftshifter_Nbit;

architecture structure of leftshifter_Nbit is
	component mux_1bit_2in
		port(c_S : in  std_logic;
			 i_A : in  std_logic;
			 i_B : in  std_logic;
			 o_D : out std_logic);
	end component;

	signal s_levelOut : array_Nbit(A downto 0, N - 1 downto 0);

begin

	-----------------------------------------------
	-- Multiple Mux Levels                       --
	-----------------------------------------------
	gen_levels : for Level in 0 to A - 1 generate
		gen_lsbmux : for Mux in 0 to N - (2 ** Level) - 1 generate
			lsbmux : mux_1bit_2in
				port map(c_S => c_Shamt(Level),
					     i_A => s_levelOut(Level,
						 Mux),
					     i_B => s_levelOut(Level,
						 Mux + (2 ** Level)),
					     o_D => s_levelOut(Level + 1,
						 Mux));
		end generate gen_lsbmux;

		gen_msbmux : for Mux in N - (2 ** Level) to N - 1 generate
			msbmux : mux_1bit_2in
				port map(c_S => c_Shamt(Level),
					     i_A => s_levelOut(Level,
						 Mux),
					     i_B => '0',
					     o_D => s_levelOut(Level + 1,
						 Mux));
		end generate gen_msbmux;
	end generate gen_levels;

	-- See rightshifter. Exact same gate structure, just input and output bits are mirrored (bit 0 -> bit N-1, bit 1 -> bit N-2 etc...)
	gen_connectregbits : for I in 0 to N - 1 generate
		s_levelOut(0, I) <= i_A(N - 1 - I);
		o_D(I)           <= s_levelOut(A, N - 1 - I);
	end generate gen_connectregbits;

end structure;
