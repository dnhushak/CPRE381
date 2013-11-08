library IEEE;
use IEEE.std_logic_1164.all;


entity nbitmux2to1dataflow is

  generic(N : integer := 2);
  port(i_C              : in std_logic;
       i_X 		: in std_logic_vector(N-1 downto 0);
       i_Y              : in std_logic_vector(N-1 downto 0);
       o_M 		: out std_logic_vector(N-1 downto 0));

end nbitmux2to1dataflow;

architecture structure of nbitmux2to1dataflow is

begin

  --IF C == 0, THEN X, C == 1, THEN Y
    g1: for I in 0 to N-1 generate
       o_M(I) <= (i_X(I) and not i_C) or (i_Y(I) and i_C);
    end generate g1;
    
end structure;
