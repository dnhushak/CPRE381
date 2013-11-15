-- adder.vhd
--
-- The adders used for calculating PC-plus-4 and branch targets
-- CprE 381
--
-- Zhao Zhang, Fall 2013
--

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.mips32.all;

entity adder is
	generic(N : integer := 32);
	port(src1   : in  m32_word;
		 src2   : in  m32_word;
		 result : out m32_word);
end entity;

-- Behavior modeling of ADDER
architecture behavior of adder is
begin
	ADD : process(src1, src2)
		variable a : integer;
		variable b : integer;
		variable c : integer;
	begin
		-- Pre-calculate
		a := to_integer(signed(src1));
		b := to_integer(signed(src2));
		c := a + b;

		-- Convert integer to 32-bit signal
		result <= std_logic_vector(to_signed(c, result'length));
	end process;
end behavior;

architecture structure of adder is
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