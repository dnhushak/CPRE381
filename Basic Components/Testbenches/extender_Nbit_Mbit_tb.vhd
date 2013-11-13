library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity extencer_Nbit_Mbit_tb is
end extencer_Nbit_Mbit_tb;

architecture behavior of extencer_Nbit_Mbit_tb is
	component extender_Nbit_Mbit
		generic(N : integer;
			    M : integer);
		port(c_Ext : in  std_logic;       --Control Input (0 is zero exnension, 1 is sign extension)
			 i_A : in  std_logic_vector(N - 1 downto 0); --N-bit Input
			 o_D : out std_logic_vector(M - 1 downto 0)); --Full Word Output
	end component;

	signal s_byte : std_logic_vector(7 downto 0);
	signal s_half : std_logic_vector(15 downto 0);
	signal s_c    : std_logic;

	signal s_byteExtended : std_logic_vector(31 downto 0);
	signal s_halfExtended : std_logic_vector(31 downto 0);

begin
	HALFWORD : extender_Nbit_Mbit
		generic map(N => 16, M => 32)
		port map(c_Ext => s_c,
			     i_A => s_half,
			     o_D => s_halfExtended);

	BYTE : extender_Nbit_Mbit
		generic map(N => 8, M => 32)
		port map(c_Ext => s_c,
			     i_A => s_byte,
			     o_D => s_byteExtended);

	-- Testbench process  
	P_TB : process
	begin

		--Initialize byte, halfword, and control
		for I in 0 to 7 loop
			s_byte(I) <= '0';
		end loop;

		for I in 0 to 15 loop
			s_half(I) <= '0';
		end loop;

		s_C <= '0';
		wait for 10 ns;

		--Increment byte
		for I in 0 to 7 loop
			s_byte(I) <= '1';
			wait for 10 ns;
		end loop;

		--Increment halfword
		for I in 0 to 15 loop
			s_half(I) <= '1';
			wait for 10 ns;
		end loop;

		--Initialize byte, halfword, and control=1
		for I in 0 to 7 loop
			s_byte(I) <= '0';
		end loop;

		for I in 0 to 15 loop
			s_half(I) <= '0';
		end loop;

		s_C <= '1';
		wait for 10 ns;

		--Increment byte
		for I in 0 to 7 loop
			s_byte(I) <= '1';
			wait for 10 ns;
		end loop;

		--Increment halfword
		for I in 0 to 15 loop
			s_half(I) <= '1';
			wait for 10 ns;
		end loop;

	end process;

end behavior;
