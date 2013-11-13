library IEEE;
use IEEE.std_logic_1164.all;

entity nand_2in is
	port(i_A : in  std_logic;
		 i_B : in  std_logic;
		 o_D : out std_logic);

end nand_2in;

architecture dataflow of nand_2in is
begin
	o_D <= i_A nand i_B;

end dataflow;
