library IEEE;
use IEEE.std_logic_1164.all;

entity addersubtracter_Nbit_tb is
	generic(BITS : integer := 4);
end addersubtracter_Nbit_tb;

architecture behavior of addersubtracter_Nbit_tb is

	-- Declare the component we are going to instantiate

	component addersubtractor_Nbit is
		generic(N : integer := BITS);
		port(i_A   : in  std_logic_vector(N - 1 downto 0);
			 i_B   : in  std_logic_vector(N - 1 downto 0);
			 c_Sub : in  std_logic;
			 o_D   : out std_logic_vector(N - 1 downto 0);
			 o_C   : out std_logic);

	end component;

	---------------------------------

	signal s_X, s_Y, s_O : std_logic_vector(BITS - 1 downto 0);
	signal s_sub, s_Co   : std_logic;

begin
	DUT : addersubtractor_Nbit
		port map(i_A   => s_X,
			     i_B   => s_Y,
			     c_Sub => s_sub,
			     o_D   => s_O,
			     o_C   => s_Co);

	process
	begin

		-- Initialize Signals--
		s_sub <= '0';
		for I in 0 to BITS - 1 loop
			s_X(I) <= '0';
			s_Y(I) <= '0';
		end loop;

		wait for 10 ns;

		-- Loop through X and Y values @ Control = 0 --
		for I in 0 to BITS - 1 loop
			s_X(I) <= '1';
			wait for 10 ns;
			s_Y(I) <= '1';
			wait for 10 ns;
		end loop;

		-- Reinitialize X and Y, set C = 1 --
		s_sub <= '1';
		for I in 0 to BITS - 1 loop
			s_X(I) <= '0';
			s_Y(I) <= '0';
		end loop;

		wait for 10 ns;

		-- Loop through X and Y values @ Control = 1 --    
		for I in 0 to BITS - 1 loop
			s_X(I) <= '1';
			wait for 10 ns;
			s_Y(I) <= '1';
			wait for 10 ns;
		end loop;

	end process;
end behavior;
