library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use IEEE.numeric_std.all;

entity ALU_Nbit is
	generic(N : integer := 8;
		    A : integer := 3);
	port(i_A     : in  std_logic_vector(N - 1 downto 0); --Input A
		 i_B     : in  std_logic_vector(N - 1 downto 0); --Input B
		 i_Ainv  : in  std_logic;       --Invert A
		 i_Binv  : in  std_logic;       --Invert B
		 i_C     : in  std_logic;       --Carry In
		 c_Op    : in  std_logic_vector(2 downto 0); --Operation
		 c_Shift : in  std_logic_vector(1 downto 0); -- Shift select: 01 => sll, 10  =>  srl, 11  => sra
		 o_D     : out std_logic_vector(N - 1 downto 0); --Output Result
		 o_OF    : out std_logic;       --Overflow Output
		 o_Zero  : out std_logic);      --Zero Output

end ALU_Nbit;

architecture structure of ALU_Nbit is
	component ALU_1bit
		port(i_A    : in  std_logic;    --Input A
			 i_B    : in  std_logic;    --Input B
			 i_Ainv : in  std_logic;    --Invert A
			 i_Binv : in  std_logic;    --Invert B
			 i_C    : in  std_logic;    --Carry In
			 i_L    : in  std_logic;    --Input "Less"
			 c_Op   : in  std_logic_vector(2 downto 0); --Operation
			 o_D    : out std_logic;    --Output Result
			 o_C    : out std_logic;    --Carry Out
			 o_Set  : out std_logic);   --Set Out   
	end component;

	component leftshifter_Nbit
		generic(N : integer := N;
			    A : integer := A);
		port(i_A     : in  std_logic_vector(N - 1 downto 0);
			 c_shamt : in  std_logic_vector(A - 1 downto 0);
			 o_D     : out std_logic_vector(N - 1 downto 0));
	end component;

	component rightshifter_Nbit
		generic(N : integer := N;
			    A : integer := A);
		port(i_A     : in  std_logic_vector(N - 1 downto 0);
			 c_shamt : in  std_logic_vector(A - 1 downto 0);
			 c_Ext   : in  std_logic;
			 o_D     : out std_logic_vector(N - 1 downto 0));
	end component;

	component mux_Nbit_Min is
		generic(N : integer := N;
			    M : integer := 4;
			    A : integer := 2);      -- Number of bits in the inputs and output
		port(c_S : in  std_logic_vector(A - 1 downto 0);
			 i_A : in  array_Nbit(M - 1 downto 0, N - 1 downto 0);
			 o_D : out std_logic_vector(N - 1 downto 0));
	end component;

	component xor_2in
		port(i_A : in  std_logic;
			 i_B : in  std_logic;
			 o_D : out std_logic);
	end component;

	component or_Nin
		generic(N : integer);
		port(i_A : in  std_logic_vector(N - 1 downto 0);
			 o_D : out std_logic);

	end component;

	component inv_1bit
		port(i_A : in  std_logic;
			 o_D : out std_logic);
	end component;

	-- Signals
	signal s_Carry, s_Set, s_Leftshifted, s_Rightshifted, s_ALUout, s_Shifted : std_logic_vector(N - 1 downto 0) := (others => '0');
	signal s_Orout                                                            : std_logic;
	signal s_Outputs                                                          : array_Nbit(3 downto 0, N - 1 downto 0);
begin
	---------------------------------------------------------
	--LSB: 1 Bit ALU with Less routed to "Set" of MSB	   --
	---------------------------------------------------------

	LSB : ALU_1bit
		port map(i_A    => i_A(0),
			     i_B    => i_B(0),
			     i_Ainv => i_Ainv,
			     i_Binv => i_Binv,
			     i_C    => i_C,
			     i_L    => s_Set(N - 1),
			     c_Op   => c_Op,
			     o_D    => s_ALUout(0),
			     o_C    => s_Carry(0),
			     o_Set  => s_Set(0));

	---------------------------------------------------------
	--MSB's: 1 Bit ALU's								   --
	---------------------------------------------------------
	MSB : for I in 1 to N - 1 generate
		gen_MSB : ALU_1bit
			port map(i_A    => i_A(I),
				     i_B    => i_B(I),
				     i_Ainv => i_Ainv,
				     i_Binv => i_Binv,
				     i_C    => s_Carry(I - 1),
				     i_L    => '0',
				     c_Op   => c_Op,
				     o_D    => s_ALUout(I),
				     o_C    => s_Carry(I),
				     o_Set  => s_Set(I));
	end generate MSB;

	---------------------------------------------------------
	--Shifters											   --
	---------------------------------------------------------

	LEFTSHIFTER : leftshifter_Nbit
		generic map(N => N, A => A)
		port map(i_A     => i_B,
			     c_Shamt => i_A(A - 1 downto 0),
			     o_D     => s_leftshifted);

	RIGHTSHIFTER : rightshifter_Nbit
		generic map(N => N, A => A)
		port map(i_A     => i_B,
			     c_Shamt => i_A(A - 1 downto 0),
			     c_Ext   => c_Shift(0),
			     o_D     => s_rightshifted);

	---------------------------------------------------------
	--LEVEL 2: XOR of Cin(31) and Cout(31) for overflow    --
	---------------------------------------------------------

	OFXOR : xor_2in
		port map(i_A => s_Carry(N - 1),
			     i_B => s_Carry(N - 2),
			     o_D => o_OF);

	---------------------------------------------------------
	--LEVEL 3: OR of all Adder Outputs for zero output	   --
	---------------------------------------------------------

	ZEROOR : or_Nin
		generic map(N => N)
		port map(i_A => s_Set,
			     o_D => s_Orout);

	ZEROINV : inv_1bit
		port map(i_A => s_Orout,
			     o_D => o_Zero);

	---------------------------------------------------------
	--LEVEL 3: MUX of outputs to select shifters	       --
	---------------------------------------------------------
	CONNECTOUTS : for I in 0 to N - 1 generate
		s_Outputs(0, I) <= s_ALUout(I);
		s_Outputs(1, I) <= s_Leftshifted(I);
		s_Outputs(2, I) <= s_Rightshifted(I);
		s_Outputs(3, I) <= s_Rightshifted(I);
	end generate CONNECTOUTS;

	SHIFTSELECT : mux_Nbit_Min
		generic map(N => N, M => 4, A => 2)
		port map(i_A => s_Outputs,
			     c_S => c_Shift,
			     o_D => o_D);

end structure;
