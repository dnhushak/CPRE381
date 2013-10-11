library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use IEEE.numeric_std.all;

entity ALU_1bit is
  port(			i_A             : in std_logic;						--Input A
       			i_B 			: in std_logic;						--Input B
       			i_Ainv          : in std_logic;						--Invert A
       			i_Binv			: in std_logic;						--Invert B
       			i_C				: in std_logic;						--Carry In
      			i_L		        : in std_logic;						--Input "Less"
      			i_Op			: in std_logic_vector(1 downto 0);	--Operation
       			o_R 			: out std_logic;					--Output Result
       			o_C             : out std_logic);					--Carry Out

end ALU_1bit;

architecture structure of ALU_1bit is
  
	component fulladder_1bit
	  port(		i_A      		: in std_logic;
		   		i_B 			: in std_logic;
		   		i_C      		: in std_logic;
		   		o_S 			: out std_logic;
		   		o_C				: out std_logic);
	end component;

	component mux_Nbit_Min
	  generic(	N 				: integer; M : integer; A : integer);
	  port(		i_C  			: in std_logic_vector(A - 1 downto 0);
		   		i_X 			: in array_Nbit(M-1 downto 0, N-1 downto 0);
		  		o_M				: out std_logic_vector(N-1 downto 0));
	end component;


	component and2
		port(	i_A             : in std_logic;
		     	i_B             : in std_logic;
		     	o_F             : out std_logic);
	end component;
	
	component or2
		port(	i_A             : in std_logic;
		     	i_B             : in std_logic;
		     	o_F             : out std_logic);
	end component;
	
	component inv
  		port(	i_A          	: in std_logic;
       			o_F          	: out std_logic);
	end component;
  
  -- Signals
  signal Ainv, Binv, Amux, Bmux, Andout, Orout, Addout : std_logic :='0';

begin
	---------------------------------------------------------
	--LEVEL 1: Invert A and B, mux between A and B inverted--
	---------------------------------------------------------
	
	INVA: inv
	port map(		i_A => i_A,
					o_F => Ainv);
				
	MUXA: mux_Nbit_Min
	generic map(	N => 1,
					M => 2,
					A => 1)
	port map(		i_C(0) => i_Ainv,
					i_X(0)(0) => i_A,
					i_X(0)(1) => Ainv,
					o_M(0) => Amux);				
				
	INVB: inv
	port map(		i_A => i_B,
					o_F => Binv);
					
	MUXB: mux_Nbit_Min
	generic map(	N => 1,
					M => 2,
					A => 1)
	port map(		i_C(0) => i_Binv,
					i_X(0)(0) => i_B,
					i_X(1)(0) => Binv,
					o_M(0) => Bmux);


	---------------------------------------------------------
	--LEVEL 2: AND, OR, and 1-bit ADDER 				   --
	---------------------------------------------------------

	ANDAB: and2
	port map(		i_A => Amux,
					i_B => Bmux,
					o_F => Andout);
					
	ORAB: or2
	port map(		i_A => Amux,
					i_B => Bmux,
					o_F => Orout);
										
	ADDAB: fulladder_1bit
	port map(		i_A => Amux,
					i_B => Bmux,
					i_C => i_C,
					o_S => Addout,
					o_C => o_C);
					
	---------------------------------------------------------
	--LEVEL 3: Control Muxing							   --
	---------------------------------------------------------
	
	CONTROLMUX: mux_Nbit_Min
	generic map(	N => 1,
					M => 4,
					A => 2)
	port map(		i_C => i_Op,
					i_X(0)(0) => Andout,
					i_X(1)(0) => Orout,
					i_X(2)(0) => Addout,
					i_X(3)(0) => i_L,
					o_M(0) => o_R);
    
  
end structure;
