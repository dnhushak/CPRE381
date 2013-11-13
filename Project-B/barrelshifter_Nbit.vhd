library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;

entity barrelshifter_Nbit is
	-- N is number of input bits (must be a power of 2)
	-- A is size of shift amount (A^2 = N)
	generic(N : integer := 32;
		    A : integer := 5);
	port(i_A   : in  std_logic_vector(N - 1 downto 0); -- input to shift
		 i_S   : in  std_logic_vector(A - 1 downto 0); -- amount to shift by
		 i_Ext : in  std_logic;         -- determines whether to fill front end with 1 or 0 (always 0 when left shift)
		 o_F   : out std_logic_vector(N - 1 downto 0)); -- shifted output

end barrelshifter_Nbit;

architecture structure of barrelshifter_Nbit is
	component mux_1bit_2in
		port(i_C : in  std_logic;
			 i_X : in  std_logic;
			 i_Y : in  std_logic;
			 o_M : out std_logic);
	end component;

	signal levelOut  : array_Nbit(A - 1 downto 1)(N - 1 downto 0);
	signal extension : std_logic;

begin

	-----------------------------------------------
	-- Sign Extension Mux                        --
	-----------------------------------------------
	SignExtendSelect : mux_1bit_2in
		port map(i_C => i_Ext,
			     i_X => '0',
			     i_Y => i_A(N - 1),
			     o_M => extension);

	-----------------------------------------------
	-- Multiple Mux Levels                       --
	-----------------------------------------------
	gen_levels : for Level in 0 to A - 1 generate
		gen_lsbmux : for Mux in 0 to N - (2 ** Level) - 1 generate
			mux : mux_1bit_2in
				port map(i_C => i_S(Level),
					     i_X => i_A(Mux),
					     i_Y => i_A(Mux + (2 ** Level)),
					     o_M => levelOut(Level,
						 Mux));
		end generate gen_lsbmux;

		gen_msbmux : for Mux in N - (2 ** Level) - 1 to N - 1 generate
			mux : mux_1bit_2in
				port map(i_C => i_S(Level),
					     i_X => i_A(Mux),
					     i_Y => extension,
					     o_M => levelOut(Level,
						 Mux));
		end generate gen_msbmux;
	end generate gen_levels;


	gen_connectregbits : for I in 0 to N - 1 generate
		o_F(I) <= levelOut(A - 1)(I);
	end generate gen_connectregbits;
	
end structure;
