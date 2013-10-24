
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.utils.all;

entity mux_tb is
	--N is I/O width, M is number of inputs (power of 2), A is address size (2^A must be = M)
	generic(N : integer := 2; M : integer := 32; A : integer := 5);
end mux_tb;

architecture behavior of mux_tb is
  
  component mux_Nbit_Min
	  generic(N : integer := N; M : integer := M; A : integer := A);
	  port(i_C  : in std_logic_vector;
	       i_X 	: in array_Nbit;
	       o_M 	: out std_logic_vector);
  end component;

  signal s_C : std_logic_vector(A - 1 downto 0) := (others => '0');
  signal s_O : std_logic_vector(N - 1 downto 0);
  signal s_X : array_Nbit(M-1 downto 0, N-1 downto 0) := (others=>(others=>'0'));

begin

  DUT: mux_Nbit_Min
  port map(i_C => s_C, 
           i_X => s_X,
           o_M  => s_O);

  
  -- Testbench process  
  P_TB: process
  begin
    
    --Initialize X logic vectors (each one will have a single 1)
    for I in 0 to M-1 loop
    	for J in 0 to N-1 loop
    		s_X(I, J) <= '0';
		end loop;
      s_X(I, I mod (N-1)) <= '1';
    end loop;
    
    --Initialize Encoding value
	for I in 0 to A - 1 loop
     	 s_C(I) <= '0';
    	end loop;
    wait for 10 ns;
    
    wait for 10 ns;

	--Increment control value
	for I in 0 to M - 1 loop
		s_C <= std_logic_vector( unsigned(s_C) + 1);
		wait for 10 ns;
    end loop;

    
  end process;
  
end behavior;
