library IEEE;
use IEEE.std_logic_1164.all;

entity inv_1bit is
	port(i_A : in  std_logic;
		 o_D : out std_logic);

end inv_1bit;

architecture dataflow of inv_1bit is
begin
	o_D <= not i_A;

end dataflow;
