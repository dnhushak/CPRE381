library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dmem_tb is
	--Half period of one clock cycle
	generic(gCLK_HPER : time := 50 ns);
end dmem_tb;

architecture behavior of dmem_tb is

	-- Calculate the clock period as twice the half-period
	--  constant cCLK_PER  : time := gCLK_HPER * 2;

	component mem
		generic(depth_exp_of_2 : integer := 10;
			    mif_filename   : string  := "dmem.mif");
		port(address : IN  STD_LOGIC_VECTOR(depth_exp_of_2 - 1 DOWNTO 0) := (OTHERS => '0');
			 byteena : IN  STD_LOGIC_VECTOR(3 DOWNTO 0)                  := (OTHERS => '1');
			 clock   : IN  STD_LOGIC                                     := '1';
			 data    : IN  STD_LOGIC_VECTOR(31 DOWNTO 0)                 := (OTHERS => '0');
			 wren    : IN  STD_LOGIC                                     := '0';
			 q       : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
	end component;

	--Clock and global write enable
	signal s_CLK, s_WE : std_logic := '0';

	--Read/Write address
	signal s_addr : std_logic_vector(9 downto 0) := (OTHERS => '0');

	--Read/Write byte enable
	signal s_byteena : std_logic_vector(3 downto 0) := (OTHERS => '1');

	--Data in and out
	signal s_datain, s_dataout : std_logic_vector(31 downto 0) := (OTHERS => '0');

begin
	DMEM : mem
		port map(address => s_addr,
			     byteena => s_byteena,
			     clock   => s_CLK,
			     data    => s_dataout,
			     wren    => s_WE,
			     q       => s_dataout);

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

		--read address = 0
		s_addr <= (others => '0');

		for I in 0 to 9 loop

			--Read data at address (placing it in the datain signal
			wait for 2 * gCLK_HPER;
			s_datain <= s_dataout;

			--set new write address
			s_addr <= std_logic_vector(unsigned(s_addr) + 100);

			--Enable write, which writes what is in datain into the new memory address
			s_WE <= '1';
			wait for 2 * gCLK_HPER;

			--Disable write
			s_WE <= '0';
			wait for 2 * gCLK_HPER;

			--Set next read address;
			s_addr <= std_logic_vector(unsigned(s_addr) - 99);
		end loop;

	end process;

end behavior;
