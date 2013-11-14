library IEEE;
use IEEE.std_logic_1164.all;

entity dff is
	port(c_CLK : in  std_logic;         -- Clock input
		 c_RST : in  std_logic;         -- Reset input
		 c_WE  : in  std_logic;         -- Write enable input
		 i_A   : in  std_logic;         -- Data value input
		 o_D   : out std_logic);        -- Data value output

end dff;

architecture mixed of dff is
	signal s_D : std_logic;             -- Multiplexed input to the FF
	signal s_Q : std_logic;             -- Output of the FF

begin

	-- The output of the FF is fixed to s_Q
	o_D <= s_Q;

	-- Create a multiplexed input to the FF based on c_WE
	with c_WE select s_D <=
		i_A when '1',
		s_Q when others;

	-- This process handles the asyncrhonous reset and
	-- synchronous write. We want to be able to reset 
	-- our processor's registers so that we minimize
	-- glitchy behavior on startup.
	process(c_CLK, c_RST)
	begin
		if (c_RST = '1') then
			s_Q <= '0';                 -- Use "(others => '0')" for N-bit values
		elsif (rising_edge(c_CLK)) then
			s_Q <= s_D;
		end if;

	end process;

end mixed;
