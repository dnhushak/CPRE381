library IEEE;
use IEEE.std_logic_1164.all;

entity extender_Nbit_Mbit is
  --N is input size, M is output word size
  generic(N : integer := 8; M : integer := 32);
  port(i_C          : in std_logic;							--Control Input (0 is zero exnension, 1 is sign extension)
       i_N          : in std_logic_vector(N-1 downto 0);		--N-bit Input
       o_W          : out std_logic_vector(M-1 downto 0));	--Full Word Output

end extender_Nbit_Mbit;

architecture dataflow of extender_Nbit_Mbit is

	component and2
		port( i_A          : in std_logic;
			   i_B          : in std_logic;
			   o_F          : out std_logic);
	end component;
	
begin

	gen_ands: for I in N to M-1 generate
      	g_ands : and2
      	port map(i_A => i_C,
	       i_B => i_N(N-1),
	       o_F => o_W(I));
	end generate gen_ands;
	
	gen_input: for J in 0 to N-1 generate
		o_W(J) <= i_N(J);
	end generate gen_input;


end dataflow;
