library IEEE;
use IEEE.std_logic_1164.all;

-- This is an empty entity so we don't need to declare ports
entity addTest is
	generic(BITS : integer := 4);
end addTest;

architecture behavior of addTest is


-- Declare the component we are going to instantiate

component nbitfulladder
  generic(N : integer := BITS);
  port(i_A              : in std_logic_vector(BITS-1 downto 0);
       i_B 		: in std_logic_vector(BITS-1 downto 0);
       i_C		: in std_logic;
       o_S              : out std_logic_vector(BITS-1 downto 0);
       o_C 		: out std_logic);
end component;


component nbitfulladderdataflow
  generic(N : integer := BITS);
  port(i_A              : in std_logic_vector(BITS-1 downto 0);
       i_B 		: in std_logic_vector(BITS-1 downto 0);
       i_C		: in std_logic;
       o_S              : out std_logic_vector(BITS-1 downto 0);
       o_C 		: out std_logic);
end component;


---------------------------------

signal s_X, s_Y, s_O, s_O2: std_logic_vector(BITS-1 downto 0);
signal  s_C, s_Co, s_Co2 : std_logic;

begin

DUT: nbitfulladder
  port map( 	i_A => s_X,
		i_B => s_Y,
		i_C => s_C,
           	o_S => s_O,
           	o_C => s_Co);
           	
DUT2: nbitfulladderdataflow
  port map( 	i_A => s_X,
		i_B => s_Y,
		i_C => s_C,
           	o_S => s_O2,
           	o_C => s_Co2);
           
  
  process
  begin
    
    -- Initialize Signals--
    s_C <= '0';
    for I in 0 to BITS - 1 loop
      s_X(I) <= '0';
      s_Y(I) <= '0';
    end loop;
    
    
    -- Loop through X and Y values @ Control = 0 --
    for I in 0 to BITS - 1 loop
      s_X(I) <= '1';
      wait for 10 ns;
      s_Y(I) <= '1';
      wait for 10 ns;
    end loop;
    
    -- Reinitialize X and Y, set C = 1 --
    s_C <= '1';    
    for I in 0 to BITS - 1 loop
      s_X(I) <= '0';
      s_Y(I) <= '0';
    end loop;
    
    -- Loop through X and Y values @ Control = 1 --    
    for I in 0 to BITS - 1 loop
      s_X(I) <= '1';
      wait for 10 ns;
      s_Y(I) <= '1';
      wait for 10 ns;
    end loop;
  


end process;
end behavior;
