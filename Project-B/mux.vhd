-------------------------------------------------------------------------
-- Robert Larsen
-------------------------------------------------------------------------


-- mux.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2 to 1 multiplexer
--
--
-- NOTES:
-- 8/27/08 by RCL::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;

entity mux is
	port (	input0  : in m32_1bit;
			input1  : in m32_1bit;
			sel     : in m32_1bit;
			output  : out m32_1bit);
end mux;

architecture structure of mux is

	component inv is
		port(	i_A : in m32_1bit;
				o_F : out m32_1bit);
	end component;
  
	component and2 is
		port( 	i_A : in m32_1bit;
				i_B : in m32_1bit;
				o_F : out m32_1bit);
	end component;
  
	component or2 is
		port( 	i_A : in m32_1bit;
				i_B : in m32_1bit;
				o_F : out m32_1bit);
	end component;
  
-- signals
signal muxControl, Aout, Bout : m32_1bit;
  
begin

-- If sel == 0, then  A, sel == 1, then B
  
---------------------------------------------------------------------------
-- Level 1: input to inverter for control
---------------------------------------------------------------------------

	g_inv: inv
		port MAP(	i_A               => sel,
					o_F               => muxControl);
             
---------------------------------------------------------------------------
-- Level 2: And gate selection
---------------------------------------------------------------------------

	g_selA: and2
		port MAP(	i_A               => input0,
					i_B               => muxControl,
					o_F               => Aout);

	g_selB: and2
		port MAP(	i_A               => input1,
					i_B               => sel,
					o_F               => Bout);
    
---------------------------------------------------------------------------
-- Level 3: OR out
---------------------------------------------------------------------------
	g_Add2: or2
		port MAP(	i_A               => Aout,
					i_B               => Bout,
					o_F               => output);

end structure;