library IEEE;
use IEEE.std_logic_1164.all;

entity tb_barrelshift is

end tb_barrelshift;

architecture behavior of tb_barrelshift is
	
	component barrelshift
	generic (N : integer := 31);
	port(	i_A		:	in std_logic_vector(N downto 0);	-- input to shift
			i_S		:	in std_logic_vector(4 downto 0);	-- amount to shift by
			i_FS	:	in std_logic;						-- select signal for flipping input
			i_Ext	:	in std_logic;						-- determines whether to fill front end with 1 or 0 (always 0 when left shift)
			o_F		:	out std_logic_vector(N downto 0));	-- shifted output
end component;

signal i_Num : std_logic_vector(31 downto 0);
signal i_Sel : std_logic_vector(4 downto 0);
signal i_FlipSel, i_Extend : std_logic;

signal o_Shift : std_logic_vector(31 downto 0);

begin

DUT: barrelshift
port map(	i_A		=>	i_Num,
			i_S		=>	i_Sel,
			i_FS	=>	i_FlipSel,
			i_Ext	=>	i_Extend,
			o_F		=>	o_Shift);
			
TB: process
begin

	i_Num 		<= "10100000000000000000000000000111";
	i_Sel 		<= "00000";
	i_FlipSel 	<= '0';
	i_Extend 	<= '0';
	wait for 100 ps;
	
	i_Num 		<= "10100000000000000000000000000111";
	i_Sel 		<= "00001";
	i_FlipSel 	<= '0';
	i_Extend 	<= '0';
	wait for 100 ps;
	
	i_Num 		<= "10100000000000000000000000000111";
	i_Sel 		<= "00100";
	i_FlipSel 	<= '0';
	i_Extend 	<= '0';
	wait for 100 ps;
	
	i_Num 		<= "10100000000000000000000000000111";
	i_Sel 		<= "00111";
	i_FlipSel 	<= '0';
	i_Extend 	<= '0';
	wait for 100 ps;
	
	i_Num 		<= "10100000000000000000000000000111";
	i_Sel 		<= "10100";
	i_FlipSel 	<= '0';
	i_Extend 	<= '0';
	wait for 100 ps;
	
	i_Num 		<= "10100000000000000000000000000111";
	i_Sel 		<= "00001";
	i_FlipSel 	<= '1';
	i_Extend 	<= '0';
	wait for 100 ps;
	
	i_Num 		<= "10100000000000000000000000000111";
	i_Sel 		<= "00101";
	i_FlipSel 	<= '1';
	i_Extend 	<= '0';
	wait for 100 ps;
	
	i_Num 		<= "10100000000000000000000000000111";
	i_Sel 		<= "11001";
	i_FlipSel 	<= '1';
	i_Extend 	<= '0';
	wait for 100 ps;
	
	i_Num 		<= "10100000000000000000000000000111";
	i_Sel 		<= "00100";
	i_FlipSel 	<= '1';
	i_Extend 	<= '1';
	wait for 100 ps;
	
	i_Num 		<= "10100000000000000000000000000111";
	i_Sel 		<= "11001";
	i_FlipSel 	<= '1';
	i_Extend 	<= '1';
	wait for 100 ps;

	end process;
	
end behavior;
