-- This is a register file that is completely scalable using generics.
-- Both the number of registers and size of said registers can be changed by altering the generic values tied to them

library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use IEEE.numeric_std.all;

entity registerfile_Nbit_Mreg is
	-- N is size of register, M is number of registers (MUST be power of 2), A is size of register addresses (A MUST equal log2(M))
	generic(N : integer := 32;
		    M : integer := 32;
		    A : integer := 5);
	port(c_SLK : in  std_logic;         -- Clock input
		 i_A   : in  std_logic_vector(N - 1 downto 0); -- Data Input
		 i_Wa  : in  std_logic_vector(A - 1 downto 0); -- Write address
		 i_WE  : in  std_logic;         -- Global Write Enable
		 i_RST : in  std_logic_vector(M - 1 downto 0); -- Register Reset vector
		 i_R1a : in  std_logic_vector(A - 1 downto 0); -- Read 1 address
		 o_D1o : out std_logic_vector(N - 1 downto 0); -- Read 1 Data Output
		 i_R2a : in  std_logic_vector(A - 1 downto 0); -- Read 2 address
		 o_D2o : out std_logic_vector(N - 1 downto 0)); -- Read 2 Data Output

end registerfile_Nbit_Mreg;

architecture structure of registerfile_Nbit_Mreg is
	component register_Nbit
		generic(N : integer := N);
		port(c_SLK : in  std_logic;     -- Clock input
			 i_RST : in  std_logic;     -- Reset input
			 i_WE  : in  std_logic;     -- Write enable input
			 i_A   : in  std_logic_vector; -- Data value input
			 o_D   : out std_logic_vector); -- Data value output
	end component;

	component decoder_Nbit
		generic(N : integer := A);
		port(i_A : in  std_logic_vector; -- Addres size input
			 o_D : out std_logic_vector); -- 2^Address size decoded output
	end component;

	component and2
		port(i_A : in  std_logic;
			 i_B : in  std_logic;
			 o_D : out std_logic);
	end component;

	component mux_Nbit_Min
		generic(N : integer := N;
			    M : integer := M;
			    A : integer := A);
		port(c_S : in  std_logic_vector;
			 i_A : in  array_Nbit;
			 o_D : out std_logic_vector);
	end component;

	--Signals

	--Register Outputs
	signal s_Reg : array_Nbit(M - 1 downto 0, N - 1 downto 0);
	type singleRegOut is array (integer range <>) of std_logic_vector(N - 1 downto 0);
	signal s_RegSingle : singleRegOut(M - 1 downto 0);

	--Decoded Write Address
	signal s_Wa : std_logic_vector(M - 1 downto 0);

	--Globaly enabled decoded write address
	signal s_WE : std_logic_vector(M - 1 downto 0);

begin
	------------------------------------------------------------------------
	--Registers
	------------------------------------------------------------------------
	g_Registers : for I in 0 to M - 1 generate
		Registers : register_Nbit
			port map(c_SLK => c_SLK,
				     i_RST => i_RST(I),
				     i_WE  => s_WE(I),
				     i_A   => i_A,
				     o_D   => s_RegSingle(I));
	end generate g_Registers;

	------------------------------------------------------------------------
	--Because of the NxN array type of std_logic (array_Nbit type), 
	--the register output has to go through this intermediary RegSingle 
	-- signal because of VHDL's shortcomings in type matching
	------------------------------------------------------------------------
	gen_connectregouts : for I in 0 to M - 1 generate
		gen_connectregbits : for J in 0 to N - 1 generate
			s_Reg(I, J) <= s_RegSingle(I)(J);
		end generate gen_connectregbits;
	end generate gen_connectregouts;

	------------------------------------------------------------------------
	--Ands for global write enable
	------------------------------------------------------------------------
	g_Ands : for I in 0 to M - 1 generate
		WriteEnableAnds : and2
			port map(i_A => s_Wa(I),
				     i_B => i_WE,
				     o_D => s_WE(I));
	end generate g_Ands;

	------------------------------------------------------------------------
	--First read selector
	------------------------------------------------------------------------
	readmux1 : mux_Nbit_Min
		port map(c_S => i_R1a,
			     i_A => s_Reg,
			     o_D => o_D1o);

	------------------------------------------------------------------------
	--Second read selector
	------------------------------------------------------------------------
	readmux2 : mux_Nbit_Min
		port map(c_S => i_R2a,
			     i_A => s_Reg,
			     o_D => o_D2o);
	------------------------------------------------------------------------
	--Write address decoder   
	------------------------------------------------------------------------
	decoder : decoder_Nbit
		port map(i_A => i_Wa,
			     o_D => s_Wa);

end structure;
