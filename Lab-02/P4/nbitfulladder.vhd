library IEEE;
use IEEE.std_logic_1164.all;


entity nbitfulladder is
  generic(N : integer := 2);
  port(i_A              : in std_logic_vector(N-1 downto 0);
       i_B 		: in std_logic_vector(N-1 downto 0);
       i_C              : in std_logic;
       o_S 		: out std_logic_vector(N-1 downto 0);
       o_C		: out std_logic);

end nbitfulladder;

architecture structure of nbitfulladder is
  
  component fulladder
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         i_C		 : in std_logic;
         o_S             : out std_logic;
         o_C             : out std_logic);
  end component;
  
  -- Signals
  signal sCarry : std_logic_vector(N-1 downto 0);

begin


	g_FirstAdder : fulladder
	port map(i_A => i_A(0),
		       i_B => i_B(0),
		       i_C => i_C,
		       o_S => o_S(0),
		       o_C => sCarry(0));

	gen_adders: for I in 1 to N-2 generate
	      	g_FullAdd : fulladder 
	      	port map(i_A => i_A(I),
		       i_B => i_B(I),
		       i_C => sCarry(I-1),
		       o_S => o_S(I),
		       o_C => sCarry(I));

    	end generate gen_adders;
    	
    	g_LastAdder : fulladder
	port map(i_A => i_A(N-1),
		       i_B => i_B(N-1),
		       i_C => sCarry(N-2),
		       o_S => o_S(N-1),
		       o_C => o_C);

    
  
end structure;
