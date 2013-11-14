library IEEE;
use IEEE.std_logic_1164.all;

entity register_Nbit_tb is
	generic(gCLK_HPER : time    := 50 ns;
		    BITS      : integer := 8);
end register_Nbit_tb;

architecture behavior of register_Nbit_tb is

	-- Calculate the clock period as twice the half-period
	constant cCLK_PER : time := gCLK_HPER * 2;

	component register_Nbit
		generic(N : integer := BITS);
		port(c_CLK : in  std_logic;     -- Clock input
			 c_RST : in  std_logic;     -- Reset input
			 c_WE  : in  std_logic;     -- Write enable input
			 i_A   : in  std_logic_vector(N - 1 downto 0); -- Data value input
			 o_D   : out std_logic_vector(N - 1 downto 0)); -- Data value output
	end component;

	-- Temporary signals to connect to the register_Nbit component.
	signal s_CLK, s_RST, s_WE : std_logic;
	signal s_D, s_Q           : std_logic_vector(BITS - 1 downto 0);

begin
	DUT : register_Nbit
		port map(c_CLK => s_CLK,
			     c_RST => s_RST,
			     c_WE  => s_WE,
			     i_A   => s_D,
			     o_D   => s_Q);

	-- This process sets the clock value (low for gCLK_HPER, then high
	-- for gCLK_HPER). Absent a "wait" command, processes restart 
	-- at the beginning once they have reached the final statement.
	P_CLK : process
	begin
		s_CLK <= '0';
		wait for gCLK_HPER;
		s_CLK <= '1';
		wait for gCLK_HPER;
	end process;

	-- Testbench process  
	P_TB : process
	begin
		-- Reset the FF's
		s_RST <= '1';
		s_WE  <= '0';

		for I in 0 to BITS - 1 loop
			s_D(I) <= '0';
		end loop;

		wait for cCLK_PER;

		-- Store all '1's
		s_RST <= '0';
		s_WE  <= '1';

		for I in 0 to BITS - 1 loop
			s_D(I) <= '1';
		end loop;
		wait for cCLK_PER;

		-- Keep '1'
		s_RST <= '0';
		s_WE  <= '0';

		for I in 0 to BITS - 1 loop
			s_D(I) <= '0';
		end loop;

		wait for cCLK_PER;

		-- Store '0'    
		s_RST <= '0';
		s_WE  <= '1';

		for I in 0 to BITS - 1 loop
			s_D(I) <= '0';
		end loop;

		wait for cCLK_PER;

		-- Keep '0'
		s_RST <= '0';
		s_WE  <= '0';
		for I in 0 to BITS - 1 loop
			s_D(I) <= '1';
		end loop;
		wait for cCLK_PER;

		-- Store all '1's
		s_RST <= '0';
		s_WE  <= '1';

		for I in 0 to BITS - 1 loop
			s_D(I) <= '1';
		end loop;
		wait for cCLK_PER;

		-- Reset the FF
		s_RST <= '1';
		s_WE  <= '0';

	end process;

end behavior;
