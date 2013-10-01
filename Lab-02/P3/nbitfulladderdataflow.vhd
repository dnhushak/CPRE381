library IEEE;
use IEEE.std_logic_1164.all;


entity nbitfulladderdataflow is
 generic(N : integer := 2);
  port(i_A              : in std_logic_vector(N-1 downto 0);
       i_B 		: in std_logic_vector(N-1 downto 0);
       i_C              : in std_logic;
       o_S 		: out std_logic_vector(N-1 downto 0);
       o_C		: out std_logic);

end nbitfulladderdataflow;


architecture structure of nbitfulladderdataflow is

  signal sCarry : std_logic_vector(N-1 downto 0);

begin
	
	o_S(0) <= i_A(0) xor i_B(0) xor i_C;
	sCarry(0) <= (i_A(0) and i_B(0)) or (i_A(0) and i_C) or (i_B(0) and i_C);
    g1: for I in 1 to N-2 generate
    	o_S(I) <= i_A(I) xor i_B(I) xor sCarry(I-1);
    	sCarry(I) <= (i_A(I) and i_B(I)) or (i_A(I) and sCarry(I-1)) or (i_B(I) and sCarry(I-1));
    end generate g1;
    	o_S(N-1) <= i_A(N-1) xor i_B(N-1) xor sCarry(N-2);
    	o_C <= (i_A(N-1) and i_B(N-1)) or (i_A(N-1) and sCarry(N-2)) or (i_B(N-1) and sCarry(N-2));
    
end structure;
