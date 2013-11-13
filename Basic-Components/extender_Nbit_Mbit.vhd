library IEEE;
use IEEE.std_logic_1164.all;

entity extender_Nbit_Mbit is
	--N is input size, M is output word size
	generic(N : integer := 8;
		    M : integer := 32);
	port(c_Ext : in  std_logic;         --Control Input (0 is zero extension, 1 is sign extension)
		 i_A   : in  std_logic_vector(N - 1 downto 0); --N-bit Input
		 o_D   : out std_logic_vector(M - 1 downto 0)); --Full Word Output

end extender_Nbit_Mbit;

architecture dataflow of extender_Nbit_Mbit is
	component and_2in
		port(i_A : in  std_logic;
			 i_B : in  std_logic;
			 o_D : out std_logic);
	end component;

begin
	-- Use and gates to and the extension control input and the MSB of the input
	g_Extension : for I in N to M - 1 generate
		g_ands : and_2in
			port map(i_A => c_Ext,
				     i_B => i_A(N - 1),
				     o_D => o_D(I));
	end generate g_Extension;

	-- Pass through all bits of the input to the LSB's of the output
	g_PassThru : for J in 0 to N - 1 generate
		o_D(J) <= i_A(J);
	end generate g_PassThru;

end dataflow;
