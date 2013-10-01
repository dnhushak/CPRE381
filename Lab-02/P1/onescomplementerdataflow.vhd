-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- inv.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 1-input NOT 
-- gate.
--
--
-- NOTES:
-- 8/27/08 by JAZ::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity onescomplementerdataflow is
  generic(N : integer);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       o_F  : out std_logic_vector(N-1 downto 0));

end onescomplementerdataflow;

architecture dataflow of onescomplementerdataflow is
  
begin
  
    g1: for I in 0 to N-1 generate
       o_F(I) <= not i_A(I);
    end generate g1;
  
end dataflow;
