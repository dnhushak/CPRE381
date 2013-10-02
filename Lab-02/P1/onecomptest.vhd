library IEEE;
use IEEE.std_logic_1164.all;

-- This is an empty entity so we don't need to declare ports
entity onecomptest is
	generic(BITS : integer := 4);
end onecomptest;

architecture behavior of onecomptest is


-- Declare the component we are going to instantiate

component onescomplementer
generic(N : integer := BITS);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       o_F  : out std_logic_vector(N-1 downto 0));

end component;

component onescomplementerdataflow
generic(N : integer := BITS);
  port(i_A  : in std_logic_vector(N-1 downto 0);
       o_F  : out std_logic_vector(N-1 downto 0));

end component;

-- Signals to connect to the and2 module
signal s_AVector, s_StructVector, S_DataVector: std_logic_vector(BITS-1 downto 0);

begin

DUT: onescomplementer
  port map( i_A  => s_AVector,
            o_F  => s_StructVector);
            
DUT2: onescomplementerdataflow
  port map( i_A  => s_AVector,
            o_F  => s_DataVector);
			
			
			
  process
  begin
	
	for I in 0 to BITS - 1 loop
      s_AVector(I) <= '0';
    end loop;
    wait for 10 ns;
    
    for I in 0 to BITS - 1 loop
      s_AVector(I) <= '1';
      wait for 10 ns;
    end loop;


end process;
end behavior;
