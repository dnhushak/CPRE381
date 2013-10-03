library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder_tb is
end decoder_tb;

architecture behavior of decoder_tb is


-- Declare the component we are going to instantiate

component decoder5to32
	port(	i_A : in std_logic_vector(4 downto 0);
			o_R : out std_logic_vector(31 downto 0));
end component;

component nbitdecoder
	generic(INBITS : integer := 5);
	port(	i_A : in std_logic_vector(INBITS downto 0);
			o_R : out std_logic_vector(2 ** INBITS downto 0));
end component;


signal s_Encoded : std_logic_vector(4 downto 0);
signal s_Decoded, s_Decodedn : std_logic_vector(31 downto 0);

begin

DUT: decoder5to32
  port map( i_A  => s_Encoded,
            o_R  => s_Decoded);
            
DUT2: nbitdecoder
  port map( i_A  => s_Encoded,
            o_R  => s_Decodedn);
            
			
			
  process
  begin
	--Initialize
	for I in 0 to 4 loop
     	 s_Encoded(I) <= '0';
    	end loop;
    wait for 10 ns;
    
	--Increment the Encoded signal by 1 every 10 ns
    for I in 0 to 31 loop
		s_Encoded <= std_logic_vector( unsigned(s_Encoded) + 1);
		wait for 10 ns;
    end loop;


end process;
end behavior;
