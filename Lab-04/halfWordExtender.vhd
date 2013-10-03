library IEEE;
use IEEE.std_logic_1164.all;

entity halfWordExtender is

  port(i_C          : in std_logic;							--Control Input (0 is zero exnension, 1 is sign extension)
       i_H          : in std_logic_vector(15 downto 0);		--Half Word Input
       o_W          : out std_logic_vector(31 downto 0));	--Full Word Output

end halfWordExtender;

architecture dataflow of halfWordExtender is

	component and2
		port( i_A          : in std_logic;
			   i_B          : in std_logic;
			   o_F          : out std_logic);
	end component;
	
begin

	gen_ands: for I in 16 to 31 generate
      	g_ands : and2
      	port map(i_A => i_C,
	       i_B => i_H(15),
	       o_F => o_W(I));
	end generate gen_ands;
	
	gen_input: for J in 0 to 15 generate
		o_W(J) <= i_H(J);
	end generate gen_input;


end dataflow;
