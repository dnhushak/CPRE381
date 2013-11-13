library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity decoder_Nbit_tb is
	generic(INBITS : integer := 5);
	signal OUTBITS : integer := 2 ** INBITS;
end decoder_Nbit_tb;

architecture behavior of decoder_Nbit_tb is

	component decoder_Nbit
		generic(N : integer := INBITS);
		port(i_A : in  std_logic_vector;
			 o_R : out std_logic_vector);
	end component;

	signal s_Encoded  : std_logic_vector(INBITS - 1 downto 0) := (others => '0');
	signal s_Decodedn : std_logic_vector(OUTBITS - 1 downto 0);

begin
	decoder : decoder_Nbit
		port map(i_A => s_Encoded,
			     o_R => s_Decodedn);

	process
	begin
		--Initialize
		for I in 0 to INBITS - 1 loop
			s_Encoded(I) <= '0';
		end loop;
		wait for 10 ns;

		--Increment the Encoded signal by 1 every 10 ns
		for I in 0 to OUTBITS - 1 loop
			s_Encoded <= std_logic_vector(unsigned(s_Encoded) + 1);
			wait for 10 ns;
		end loop;

	end process;
end behavior;
