library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;

entity rightshifter_Nbit is
	-- N is number of input bits (must be a power of 2)
	-- A is size of shift amount (A^2 = N)
	generic(N : integer := 32;
		    A : integer := 5);
	port(i_A     : in  std_logic_vector(N - 1 downto 0); -- input to shift
		 c_Shamt : in  std_logic_vector(A - 1 downto 0); -- amount to shift by
		 c_Ext   : in  std_logic;       -- determines whether to fill front end with 1 or 0 (always 0 when left shift)
		 o_D     : out std_logic_vector(N - 1 downto 0)); -- shifted output

end rightshifter_Nbit;

architecture structure of rightshifter_Nbit is
	component mux_1bit_2in
		port(c_S : in  std_logic;
			 i_A : in  std_logic;
			 i_B : in  std_logic;
			 o_D : out std_logic);
	end component;

	signal s_levelOut  : array_Nbit(A - 1 downto 0, N - 1 downto 0);
	signal s_extension : std_logic;

begin

	-----------------------------------------------
	-- Sign s_extension Mux                        --
	-----------------------------------------------
	SignExtendSelect : mux_1bit_2in
		port map(c_S => c_Ext,
			     i_A => '0',
			     i_B => i_A(N - 1),
			     o_D => s_extension);

	-----------------------------------------------
	-- Multiple Mux Levels                       --
	-----------------------------------------------
	gen_levels : for Level in 0 to A - 2 generate
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

		gen_msbmux : for Mux in N - (2 ** Level) - 1 to N - 1 generate
			msbmux : mux_1bit_2in
				port map(c_S => c_Shamt(Level),
					     i_A => s_levelOut(Level,
						 Mux),
					     i_B => s_extension,
					     o_D => s_levelOut(Level + 1,
						 Mux));
		end generate gen_msbmux;
	end generate gen_levels;

	gen_connectregbits : for I in 0 to N - 1 generate
		s_levelOut(0, I) <= i_A(I);
		o_D(I)           <= s_levelOut(A - 1, I);
	end generate gen_connectregbits;

end structure;
