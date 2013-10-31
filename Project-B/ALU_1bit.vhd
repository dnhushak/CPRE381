library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use IEEE.numeric_std.all;

entity ALU_1bit is
	port(i_A             : in std_logic; --Input A
		 i_B             : in std_logic; --Input B
		 i_Ainv          : in std_logic; --Invert A
		 i_Binv          : in std_logic; --Invert B
		 i_C             : in std_logic; --Carry In
		 i_L             : in std_logic; --Input "Less"
		 i_Op            : in std_logic_vector(2 downto 0); --Operation
		 o_R             : out std_logic; --Output Result
		 o_C             : out std_logic; --Carry Out
		 o_S             : out std_logic); -- Set Out       

		 end ALU_1bit ;

		 architecture structure of ALU_1bit is
			component fulladder_1bit
				port(i_A : in std_logic;
					i_B  : in std_logic;
					i_C  : in std_logic;
					o_S  : out std_logic;
					o_C  : out std_logic);
			end component;

			component mux_1bit_Min
				generic(
					M : integer;
					A : integer);
				port(i_C : in std_logic_vector(A - 1 downto 0);
					i_X  : in std_logic_vector(M - 1 downto 0);
					o_M  : out std_logic);
			end component;

			component and2
				port(i_A : in std_logic;
					i_B  : in std_logic;
					o_F  : out std_logic);
			end component;

			component or2
				port(i_A : in std_logic;
					i_B  : in std_logic;
					o_F  : out std_logic);
			end component;
			
			component xor2
				port(i_A : in std_logic;
					i_B  : in std_logic;
					o_F  : out std_logic);
			end component;

			component inv
				port(i_A : in std_logic;
					o_F  : out std_logic);
			end component;

			-- Signals
			signal Ainv, Binv, Amux, Bmux, Andout, Orout, Xorout, Addout : std_logic := '0';

		 begin
			---------------------------------------------------------
			--LEVEL 1: Invert A and B, mux between A and B inverted--
			---------------------------------------------------------

			INVA : inv
				port map(i_A => i_A,
					o_F => Ainv);

			MUXA : mux_1bit_Min
				generic map(M => 2,
					A => 1)
				port map(i_C(0) => i_Ainv,
					i_X(0) => i_A,
					i_X(1) => Ainv,
					o_M => Amux);

			INVB : inv
				port map(i_A => i_B,
					o_F => Binv);

			MUXB : mux_1bit_Min
				generic map(
					M => 2,
					A => 1)
				port map(i_C(0) => i_Binv,
					i_X(0) => i_B,
					i_X(1) => Binv,
					o_M => Bmux);

			---------------------------------------------------------
			--LEVEL 2: AND, OR, XOR, and 1-bit ADDER 			   --
			---------------------------------------------------------

			ANDAB : and2
				port map(i_A => Amux,
					i_B => Bmux,
					o_F => Andout);

			ORAB : or2
				port map(i_A => Amux,
					i_B => Bmux,
					o_F => Orout);
					
			XORAB : xor2
				port map(i_A => Amux,
					i_B => Bmux,
					o_F => Xorout);

			ADDAB : fulladder_1bit
				port map(i_A => Amux,
					i_B => Bmux,
					i_C => i_C,
					o_S => Addout,
					o_C => o_C);
			
			o_S <= Addout;
			---------------------------------------------------------
			--LEVEL 3: Control Muxing							   --
			---------------------------------------------------------

			CONTROLMUX : mux_1bit_Min
				generic map(M => 8,
					A => 3)
				port map(i_C => i_Op,
					i_X(0) => Andout,
					i_X(1) => Orout,
					i_X(2) => Addout,
					i_X(3) => i_L,
					i_X(4) => Xorout,
					i_X(7 downto 5) => "000",
					o_M => o_R);

		 end structure;
