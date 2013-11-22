library IEEE;
use IEEE.std_logic_1164.all;

entity nor_2in is
	port(i_A : in  std_logic;
		 i_B : in  std_logic;
		 o_D : out std_logic);

end nor_2in;

architecture dataflow of nor_2in is
begin
	o_D <= i_A nor i_B;

end dataflow;