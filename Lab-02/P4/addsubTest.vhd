library IEEE;
use IEEE.std_logic_1164.all;

-- This is an empty entity so we don't need to declare ports
entity addsubTest is
	generic(BITS : integer := 4);
end addsubTest;

architecture behavior of addsubTest is


-- Declare the component we are going to instantiate

component addsub is
  generic(N : integer := BITS);
  port(i_A              : in std_logic_vector(N-1 downto 0);
       i_B 		: in std_logic_vector(N-1 downto 0);
       n_sub            : in std_logic;
       o_F 		: out std_logic_vector(N-1 downto 0);
       o_C              : out std_logic);

end component;



---------------------------------

signal s_X, s_Y, s_O: std_logic_vector(BITS-1 downto 0);
signal  s_sub, s_Co : std_logic;

begin

DUT: addsub
  port map( 	i_A => s_X,
		i_B => s_Y,
		n_sub => s_sub,
           	o_F => s_O,
           	o_C => s_Co);
           
  
  process
  begin
    
    -- Initialize Signals--
    s_sub <= '0';
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
    s_sub <= '1';    
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
