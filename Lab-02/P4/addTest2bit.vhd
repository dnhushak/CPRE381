library IEEE;
use IEEE.std_logic_1164.all;

-- This is an empty entity so we don't need to declare ports
entity addTest2bit is
	generic(BITS : integer := 6);
end addTest2bit;

architecture behavior of addTest2bit is


-- Declare the component we are going to instantiate

component fulladder
  port(i_A              : in std_logic;
       i_B		: in std_logic;
       i_C              : in std_logic;
       o_S 		: out std_logic;
       o_C		: out std_logic);
end component;


-- Signals to connect to the and2 module
signal s_A, s_B, s_Ci, s_S, s_Co: std_logic;

begin

DUT: fulladder
  port map( 	i_A => s_A,
		i_B => s_B,
		i_C => s_Ci,
           	o_S => s_S,
           	o_C => s_Co);
            

  -- Remember, a process executes sequentially
  -- and then if not told to 'wait for' loops back
  -- around
  
  
  process
  begin
    
    s_A <= '0';
    s_B <= '0';
    s_Ci <= '0';
    wait for 10 ns;
    
    s_A <= '1';
    s_B <= '0';
    s_Ci <= '0';
    wait for 10 ns;
    
    s_A <= '0';
    s_B <= '1';
    s_Ci <= '0';
    wait for 10 ns;
    
    s_A <= '1';
    s_B <= '1';
    s_Ci <= '0';
    wait for 10 ns;
    
    s_A <= '0';
    s_B <= '0';
    s_Ci <= '1';
    wait for 10 ns;
    
    s_A <= '1';
    s_B <= '0';
    s_Ci <= '1';
    wait for 10 ns;
    
    s_A <= '0';
    s_B <= '1';
    s_Ci <= '1';
    wait for 10 ns;
    
    s_A <= '1';
    s_B <= '1';
    s_Ci <= '1';
    wait for 10 ns;

end process;
end behavior;