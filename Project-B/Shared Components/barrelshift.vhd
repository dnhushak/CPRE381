-------------------------------------------------------------------------
-- Robert Larsen
-- Iowa State University
-------------------------------------------------------------------------


-- rightbarrelshift.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation a barrel right shifter
--
--
-- NOTES:
-- 9/07/08 by RCL::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;

entity barrelshift is
	generic(N : integer := 31);
	port(i_A   : in  m32_vector(N downto 0); -- input to shift
		 i_S   : in  m32_vector(4 downto 0); -- amount to shift by
		 i_FS  : in  m32_1bit;          -- select signal for flipping input
		 i_Ext : in  m32_1bit;          -- determines whether to fill front end with 1 or 0 (always 0 when left shift)
		 o_F   : out m32_vector(N downto 0)); -- shifted output

end barrelshift;

architecture structure of barrelshift is
	component mux
		port(input0 : in  m32_1bit;
			 input1 : in  m32_1bit;
			 sel    : in  m32_1bit;
			 output : out m32_1bit);
	end component;

	component inv
		port(i_A : in  m32_1bit;
			 o_F : out m32_1bit);
	end component;

	signal flipOut, lvlOneOut, lvlTwoOut, lvlThreeOut, lvlFourOut, lvlFiveOut : m32_vector(N downto 0);
	signal inv_select                                                         : m32_vector(4 downto 0);
	signal mux_out                                                            : m32_1bit;

begin

	--------------------------------------------------------------------------
	-- Inverts Shift bits and multiplexes sign value
	--------------------------------------------------------------------------

	gen_inv : for I in 0 to 4 generate
		invert : inv
			port MAP(i_A => i_S(I),
				     o_F => inv_select(I));
	end generate gen_inv;

	--------------------------------------------------------------------------
	-- Flips bits
	--------------------------------------------------------------------------

	gen_flip : for I in 0 to N generate
		MUX_flip : mux
			port MAP(input0 => i_A(I),  -- least significant bit?
				     input1 => i_A(N - I), -- most significant bit?
				     sel    => i_FS,    -- 0 is no flip, 1 is flip input
				     output => flipOut(I)); -- output
	end generate gen_flip;

	MUX_Sign : mux
		port MAP(input0 => '0',
			     input1 => flipOut(0),
			     sel    => i_Ext,
			     output => mux_Out);

	--------------------------------------------------------------------------
	-- Level 1
	--------------------------------------------------------------------------

	MUX_One : mux
		port MAP(input0 => flipOut(0),
			     input1 => mux_Out,
			     sel    => i_S(0),
			     output => lvlOneOut(0));

	gen_lvlOne : for I in 1 to N generate
		MUX_lvl1 : mux
			port MAP(input0 => flipOut(I),
				     input1 => flipOut(I - 1),
				     sel    => i_S(0),
				     output => lvlOneOut(I));
	end generate gen_lvlOne;

	--------------------------------------------------------------------------
	-- Level 2
	--------------------------------------------------------------------------

	gen_two : for I in 0 to 1 generate
		MUX_Two : mux
			port MAP(input0 => lvlOneOut(I),
				     input1 => mux_Out,
				     sel    => i_S(1),
				     output => lvlTwoOut(I));
	end generate gen_two;

	gen_lvlTwo : for I in 2 to N generate
		MUX_lvl2 : mux
			port MAP(input0 => lvlOneOut(I),
				     input1 => lvlOneOut(I - 2),
				     sel    => i_S(1),
				     output => lvlTwoOut(I));
	end generate gen_lvlTwo;

	---------------------------------------------------------------------------
	-- Level 3
	---------------------------------------------------------------------------

	gen_three : for I in 0 to 3 generate
		MUX_Three : mux
			port MAP(input0 => lvlTwoOut(I),
				     input1 => mux_Out,
				     sel    => i_S(2),
				     output => lvlThreeOut(I));
	end generate gen_three;

	gen_lvlThree : for I in 4 to N generate
		MUX_lvl3 : mux
			port MAP(input0 => lvlTwoOut(I),
				     input1 => lvlTwoOut(I - 4),
				     sel    => i_S(2),
				     output => lvlThreeOut(I));
	end generate gen_lvlThree;

	----------------------------------------------------------------------------
	-- Level 4
	----------------------------------------------------------------------------

	gen_four : for I in 0 to 7 generate
		MUX_Four : mux
			port MAP(input0 => lvlThreeOut(I),
				     input1 => mux_Out,
				     sel    => i_S(3),
				     output => lvlFourOut(I));
	end generate gen_four;

	gen_lvlFour : for I in 8 to N generate
		MUX_lvl4 : mux
			port MAP(input0 => lvlThreeOut(I),
				     input1 => lvlThreeOut(I - 8),
				     sel    => i_S(3),
				     output => lvlFourOut(I));
	end generate gen_lvlFour;

	-----------------------------------------------------------------------------
	-- Level 5 - Final Level
	-----------------------------------------------------------------------------

	gen_five : for I in 0 to 15 generate
		MUX_lvl1 : mux
			port MAP(input0 => lvlFourOut(I),
				     input1 => mux_Out,
				     sel    => i_S(4),
				     output => lvlFiveOut(I));
	end generate gen_five;

	gen_lvlFive : for I in 16 to N generate
		MUX_lvl5 : mux
			port MAP(input0 => lvlFourOut(I),
				     input1 => lvlFourOut(I - 16),
				     sel    => i_S(4),
				     output => lvlFiveOut(I));
	end generate gen_lvlFive;

	-------------------------------------------------------------------------------
	-- Flip output back to correct order if flipped
	-------------------------------------------------------------------------------

	gen_flip_out : for I in 0 to N generate
		MUX_Out : mux
			port MAP(input0 => lvlFiveOut(I),
				     input1 => lvlFiveOut(N - I),
				     sel    => i_FS,
				     output => o_F(I));
	end generate gen_flip_out;

end structure;
