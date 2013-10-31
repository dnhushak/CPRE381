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

entity barrelshift is
	generic (N : integer := 31);
	port(	i_A		:	in std_logic_vector(N downto 0);	-- input to shift
			i_S		:	in std_logic_vector(4 downto 0);	-- amount to shift by
			i_FS	:	in std_logic;						-- select signal for flipping input
			i_Ext	:	in std_logic;						-- determines whether to fill front end with 1 or 0 (always 0 when left shift)
			o_F		:	out std_logic_vector(N downto 0));	-- shifted output

end barrelshift;

architecture structure of barrelshift is

component mux2to1
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       i_C          : in std_logic;		-- select signal
       o_Final      : out std_logic);

end component;

component inv
  port(i_A          : in std_logic;
       o_F          : out std_logic);
end component;


signal flipOut, lvlOneOut, lvlTwoOut, lvlThreeOut, lvlFourOut, lvlFiveOut : std_logic_vector(N downto 0);
signal inv_select : std_logic_vector(4 downto 0);
signal mux_Out : std_logic;

begin

--------------------------------------------------------------------------
-- Inverts Shift bits and multiplexes sign value
--------------------------------------------------------------------------

gen_inv: for I in 0 to 4 generate
	invert : inv
	port MAP(	i_A		=>	i_S(I),
				o_F		=>	inv_select(I));
end generate gen_inv;

--------------------------------------------------------------------------
-- Flips bits
--------------------------------------------------------------------------

gen_flip: for I in 0 to N generate
	MUX : mux2to1
	port MAP(	i_A		=>	i_A(I),			-- least significant bit?
				i_B		=>	i_A(N-I),		-- most significant bit?
				i_C		=>	i_FS,			-- 0 is no flip, 1 is flip input
				o_Final	=>	flipOut(I));	-- output
end generate gen_flip;

MUX_Sign: mux2to1
	port MAP(	i_A		=>	'0',
				i_B		=>	flipOut(0),
				i_C		=>	i_Ext,
				o_Final	=>	mux_Out);

--------------------------------------------------------------------------
-- Level 1
--------------------------------------------------------------------------

	MUX_One : mux2to1
	port MAP(	i_A		=>	flipOut(0),
				i_B		=>	mux_Out,
				i_C		=>	i_S(0),
				o_Final	=>	lvlOneOut(0));

gen_lvlOne: for I in 1 to N generate
	MUX_lvl1 : mux2to1
	port MAP(	i_A		=>	flipOut(I),
				i_B		=>	flipOut(I - 1),
				i_C		=>	i_S(0),
				o_Final	=>	lvlOneOut(I));
end generate gen_lvlOne;
				
--------------------------------------------------------------------------
-- Level 2
--------------------------------------------------------------------------

gen_two: for I in 0 to 1 generate
	MUX_Two : mux2to1
	port MAP(	i_A		=>	lvlOneOut(I),
				i_B		=>	mux_Out,
				i_C		=>	i_S(1),
				o_Final	=>	lvlTwoOut(I));
end generate gen_two;

gen_lvlTwo: for I in 2 to N generate
	MUX_lvl2 : mux2to1
	port MAP(	i_A		=>	lvlOneOut(I),
				i_B		=>	lvlOneOut(I - 2),
				i_C		=>	i_S(1),
				o_Final	=>	lvlTwoOut(I));
end generate gen_lvlTwo;

---------------------------------------------------------------------------
-- Level 3
---------------------------------------------------------------------------

gen_three: for I in 0 to 3 generate
	MUX_Three : mux2to1
	port MAP(	i_A		=>	lvlTwoOut(I),
				i_B		=>	mux_Out,
				i_C		=>	i_S(2),
				o_Final	=>	lvlThreeOut(I));
end generate gen_three;

gen_lvlThree: for I in 4 to N generate
	MUX_lvl3 : mux2to1
	port MAP(	i_A		=>	lvlTwoOut(I),
				i_B		=>	lvlTwoOut(I - 4),
				i_C		=>	i_S(2),
				o_Final	=>	lvlThreeOut(I));
end generate gen_lvlThree;

----------------------------------------------------------------------------
-- Level 4
----------------------------------------------------------------------------

gen_four: for I in 0 to 7 generate
	MUX_Four : mux2to1
	port MAP(	i_A		=>	lvlThreeOut(I),
				i_B		=>	mux_Out,
				i_C		=>	i_S(3),
				o_Final	=>	lvlFourOut(I));
end generate gen_four;

gen_lvlFour: for I in 8 to N generate
	MUX_lvl4 : mux2to1
	port MAP(	i_A		=>	lvlThreeOut(I),
				i_B		=>	lvlThreeOut(I - 8),
				i_C		=>	i_S(3),
				o_Final	=>	lvlFourOut(I));
end generate gen_lvlFour;

-----------------------------------------------------------------------------
-- Level 5 - Final Level?
-----------------------------------------------------------------------------

gen_five: for I in 0 to 15 generate
	MUX_lvl1 : mux2to1
	port MAP(	i_A		=>	lvlFourOut(I),
				i_B		=>	mux_Out,
				i_C		=>	i_S(4),
				o_Final	=>	lvlFiveOut(I));
end generate gen_five;

gen_lvlFive: for I in 16 to N generate
	MUX_lvl5 : mux2to1
	port MAP(	i_A		=>	lvlFourOut(I),
				i_B		=>	lvlFourOut(I - 16),
				i_C		=>	i_S(4),
				o_Final	=>	lvlFiveOut(I));
end generate gen_lvlFive;

-------------------------------------------------------------------------------
-- Flip output back to correct order if flipped
-------------------------------------------------------------------------------

gen_flip_out: for I in 0 to N generate
	MUX_Out : mux2to1
	port MAP(	i_A		=>	lvlFiveOut(I),
				i_B		=>	lvlFiveOut(N-I),
				i_C		=>	i_FS,
				o_Final	=>	o_F(I));
end generate gen_flip_out;

end structure;
