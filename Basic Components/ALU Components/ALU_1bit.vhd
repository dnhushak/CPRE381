library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use IEEE.numeric_std.all;

entity ALU_1bit is
	port(i_A    : in  std_logic;        --Input A
		 i_B    : in  std_logic;        --Input B
		 i_Ainv : in  std_logic;        --Invert A
		 i_Binv : in  std_logic;        --Invert B
		 i_C    : in  std_logic;        --Carry In
		 i_L    : in  std_logic;        --Input "Less"
		 c_Op   : in  std_logic_vector(2 downto 0); --Operation
		 o_D    : out std_logic;        --Output Result
		 o_C    : out std_logic;        --Carry Out
		 o_Set  : out std_logic);       --Set Out       

end ALU_1bit;

architecture structure of ALU_1bit is
	component fulladder_1bit
		port(i_A : in  std_logic;
			 i_B : in  std_logic;
			 i_C : in  std_logic;
			 o_D : out std_logic;
			 o_C : out std_logic);
	end component;

	component mux_1bit_Min
		generic(M : integer;
			    A : integer);
		port(c_S : in  std_logic_vector(A - 1 downto 0);
			 i_A : in  std_logic_vector(M - 1 downto 0);
			 o_D : out std_logic);
	end component;

	component and_2in
		port(i_A : in  std_logic;
			 i_B : in  std_logic;
			 o_D : out std_logic);
	end component;

	component or_2in
		port(i_A : in  std_logic;
			 i_B : in  std_logic;
			 o_D : out std_logic);
	end component;

	component xor_2in
		port(i_A : in  std_logic;
			 i_B : in  std_logic;
			 o_D : out std_logic);
	end component;

	component inv_1bit
		port(i_A : in  std_logic;
			 o_D : out std_logic);
	end component;

	-- Signals
	signal s_Ainv, s_Binv, s_Amux, s_Bmux, Andout, s_Orout, s_Xorout, s_Addout : std_logic := '0';

begin
	---------------------------------------------------------
	--LEVEL 1: Invert A and B, mux between A and B inverted--
	---------------------------------------------------------

	INVA : inv_1bit
		port map(i_A => i_A,
			     o_D => s_Ainv);

	MUXA : mux_1bit_Min
		generic map(M => 2,
			        A => 1)
		port map(c_S(0) => i_Ainv,
			     i_A(0) => i_A,
			     i_A(1) => s_Ainv,
			     o_D    => s_Amux);

	INVB : inv_1bit
		port map(i_A => i_B,
			     o_D => s_Binv);

	MUXB : mux_1bit_Min
		generic map(
			M => 2,
			A => 1)
		port map(c_S(0) => i_Binv,
			     i_A(0) => i_B,
			     i_A(1) => s_Binv,
			     o_D    => s_Bmux);

	---------------------------------------------------------
	--LEVEL 2: AND, OR, XOR, and 1-bit ADDER 			   --
	---------------------------------------------------------

	ANDAB : and_2in
		port map(i_A => s_Amux,
			     i_B => s_Bmux,
			     o_D => Andout);

	ORAB : or_2in
		port map(i_A => s_Amux,
			     i_B => s_Bmux,
			     o_D => s_Orout);

	XORAB : xor_2in
		port map(i_A => s_Amux,
			     i_B => s_Bmux,
			     o_D => s_Xorout);

	ADDAB : fulladder_1bit
		port map(i_A => s_Amux,
			     i_B => s_Bmux,
			     i_C => i_C,
			     o_D => s_Addout,
			     o_C => o_C);

	o_Set <= s_Addout;

	---------------------------------------------------------
	--LEVEL 3: Control Muxing							   --
	---------------------------------------------------------

	CONTROLMUX : mux_1bit_Min
		generic map(M => 8,
			        A => 3)
		port map(c_S             => c_Op,
			     i_A(0)          => Andout,
			     i_A(1)          => s_Orout,
			     i_A(2)          => s_Addout,
			     i_A(3)          => i_L,
			     i_A(4)          => s_Xorout,
			     i_A(7 downto 5) => "000",
			     o_D             => o_D);

end structure;
