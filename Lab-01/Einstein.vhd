-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- Quadratic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of the Quadratic
-- equation Ax^2+Bx+C using invidual adder and multiplier units.
--
--
-- NOTES:
-- 8/19/09 by JAZ::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;


entity Einstein is

  port(iCLK             : in std_logic;
       iX 		            : in integer;
       oY 		            : out integer);

end Einstein;

architecture structure of Einstein is
  

  component Multiplier
    port(iCLK           : in std_logic;
         iA             : in integer;
         iB             : in integer;
         oC             : out integer);
  end component;

  -- Speed of light Constant
  constant C : integer := 9487;

  -- Signals to store C*C
  signal sVALUE_CC : integer; 

begin

  
  ---------------------------------------------------------------------------
  -- Level 1: Calculate C*C, m*C^2
  ---------------------------------------------------------------------------
  g_Mult1: Multiplier
    port MAP(iCLK             => iCLK,
             iA               => C,
             iB               => C,
             oC               => sVALUE_CC);

  g_Mult2: Multiplier
    port MAP(iCLK             => iCLK,
             iA               => sVALUE_CC,
             iB               => iX,
             oC               => oY);
    
 
end structure;