library IEEE;
use IEEE.std_logic_1164.all;


entity addsub is
  generic(N : integer := 2);
  port(i_A              : in std_logic_vector(N-1 downto 0);
       i_B 		: in std_logic_vector(N-1 downto 0);
       n_sub            : in std_logic;
       o_F 		: out std_logic_vector(N-1 downto 0);
       o_C              : out std_logic);

end addsub;

architecture structure of addsub is
  
component nbitfulladder
  generic(N : integer := N);
  port(i_A              : in std_logic_vector(N-1 downto 0);
       i_B 		: in std_logic_vector(N-1 downto 0);
       i_C		: in std_logic;
       o_S              : out std_logic_vector(N-1 downto 0);
       o_C 		: out std_logic);
end component;

component nbitmux2to1
generic(N : integer := N);
  port(i_C              : in std_logic;
       i_X 		: in std_logic_vector(N-1 downto 0);
       i_Y              : in std_logic_vector(N-1 downto 0);
       o_M 		: out std_logic_vector(N-1 downto 0));
end component;

component onescomplementer
 generic(N : integer := N);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       o_F  : out std_logic_vector(N-1 downto 0));

end component;
  
  -- Signals
  signal complemented, muxed : std_logic_vector(N-1 downto 0);

begin



	g_onecomp : onescomplementer
	port map(i_A => i_B,
		   o_F => complemented);

	g_muxer : nbitmux2to1
 	 port map( i_C => n_sub,
		i_X => i_B,
		i_Y => complemented,
           	o_M => muxed);

	g_fulladder: nbitfulladder
 	 port map( 	i_A => i_A,
			i_B => muxed,
			i_C => n_sub,
		   	o_S => o_F,
		   	o_C => o_C);

    
  
end structure;
