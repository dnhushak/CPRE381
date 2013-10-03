library IEEE;
use IEEE.std_logic_1164.all;

entity byteExtender is

  port(i_C          : in std_logic;							--Control Input (0 is zero exnension, 1 is sign extension)
       i_B          : in std_logic_vector(7 downto 0);		--Half Word Input
       o_W          : out std_logic_vector(31 downto 0));	--Full Word Output

end byteExtender;

architecture dataflow of byteExtender is

	component and2
		port( i_A          : in std_logic;
			   i_B          : in std_logic;
			   o_F          : out std_logic);
	end component;
	
begin

	gen_ands: for I in 8 to 31 generate
      	g_ands : and2
      	port map(i_A => i_C,
	       i_B => i_B(7),
	       o_F => o_W(I));
	end generate gen_ands;
	
	gen_input: for J in 0 to 7 generate
		o_W(J) <= i_B(J);
	end generate gen_input;


end dataflow;
