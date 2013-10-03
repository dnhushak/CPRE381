
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.arr_32.all;

entity mux_tb is
end mux_tb;

architecture behavior of mux_tb is
  
  component n32bitmux32to1 
	  generic(N : integer := 32);
	  port(i_C      : in std_logic_vector(4 downto 0);
	       i_X 	: in array32_bit(N-1 downto 0);
	       o_M 	: out std_logic_vector(N-1 downto 0));
  end component;

  signal s_C : std_logic_vector(4 downto 0);
  signal s_O : std_logic_vector(31 downto 0);
  signal s_X : array32_bit(31 downto 0);

begin

  DUT: n32bitmux32to1 
  port map(i_C => s_C, 
           i_X => s_X,
           o_M  => s_O);

  
  -- Testbench process  
  P_TB: process
  begin
    
    --Initialize X logic vectors (each one will have a single 1)
    for I in 0 to 31 loop
    	for J in 0 to 31 loop
    		s_X(I)(J) <= '0';
		end loop;
      s_X(I)(I) <= '1';
    end loop;
    
    --Initialize Encoding value
	for I in 0 to 4 loop
     	 s_C(I) <= '0';
    	end loop;
    wait for 10 ns;
    
    wait for 10 ns;

	--Increment control value
	for I in 0 to 31 loop
		s_C <= std_logic_vector( unsigned(s_C) + 1);
		wait for 10 ns;
    end loop;

    
  end process;
  
end behavior;
