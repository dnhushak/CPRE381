-------------------------------------------------------------------------
-- Robert Larsen
-------------------------------------------------------------------------


-- mux2to1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2 to 1 multiplexer
--				using mips32_vectors. Implementation is expandable by changing
--				the generic and size of select signal.
--
--
-- NOTES:
-- 8/27/08 by RCL::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;

entity mux2to1 is
	generic (M    : integer := 1);    -- Number of bits in the inputs and output
	port (	input0  : in m32_vector(M-1 downto 0);
			input1  : in m32_vector(M-1 downto 0);
			sel     : in m32_1bit;
			output  : out m32_vector(M-1 downto 0));
end mux2to1;

architecture structure of mux2to1 is

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
signal Aout, Bout : m32_vector(M-1 downto 0);
signal muxControl : m32_1bit;
  
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
gen_And: for I in 0 to M-1 generate
	g_selA: and2
		port MAP(	i_A               => input0(I),
					i_B               => muxControl,
					o_F               => Aout(I));

	g_selB: and2
		port MAP(	i_A               => input1(I),
					i_B               => sel,
					o_F               => Bout(I));
    
---------------------------------------------------------------------------
-- Level 3: OR out
---------------------------------------------------------------------------
	g_Add2: or2
		port MAP(	i_A               => Aout(I),
					i_B               => Bout(I),
					o_F               => output(I));
end generate;

end structure;
