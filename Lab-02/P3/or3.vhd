library IEEE;
use IEEE.std_logic_1164.all;

entity or3 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       i_C          : in std_logic;
       o_F          : out std_logic);

end or3;

architecture dataflow of or3 is
begin

  o_F <= (i_A or i_B or i_C);
  
end dataflow;
