-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- tb_and2.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a simple VHDL testbench for the
-- 2-input AND gate.
--
--
-- NOTES:
-- 8/31/08 by JAZ::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

-- This is an empty entity so we don't need to declare ports
entity muxTest is
	generic(BITS : integer := 6);
end muxTest;

architecture behavior of muxTest is


-- Declare the component we are going to instantiate

component nbitmux2to1
  generic(N : integer := BITS);
  port(i_C              : in std_logic;
       i_X 		: in std_logic_vector(BITS-1 downto 0);
       i_Y              : in std_logic_vector(BITS-1 downto 0);
       o_M 		: out std_logic_vector(BITS-1 downto 0));
end component;

component nbitmux2to1dataflow
  generic(N : integer := BITS);
  port(i_C              : in std_logic;
       i_X 		: in std_logic_vector(BITS-1 downto 0);
       i_Y              : in std_logic_vector(BITS-1 downto 0);
       o_M 		: out std_logic_vector(BITS-1 downto 0));
end component;

-- Signals to connect to the and2 module
signal s_X, s_Y, s_O1, s_O2: std_logic_vector(BITS-1 downto 0);
signal  s_C : std_logic;

begin

DUT: nbitmux2to1
  port map( 	i_C => s_C,
		i_X => s_X,
		i_Y => s_Y,
           	o_M => s_O1);
           	
DUT2: nbitmux2to1dataflow
  port map( 	i_C => s_C,
		i_X => s_X,
		i_Y => s_Y,
           	o_M => s_O2);
            

  -- Remember, a process executes sequentially
  -- and then if not told to 'wait' loops back
  -- around
  
  
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
    end loop;
    
    for I in 0 to BITS - 1 loop
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
    end loop;
    wait for 10 ns;
    
    for I in 0 to BITS - 1 loop
      s_Y(I) <= '1';
      wait for 10 ns;
    end loop;
  


end process;
end behavior;
