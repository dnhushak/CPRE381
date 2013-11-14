library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use IEEE.numeric_std.all;

entity ALU_Nbit is
	generic(N : integer := 2);
	port(i_A    : in  std_logic_vector(N - 1 downto 0); --Input A
		 i_B    : in  std_logic_vector(N - 1 downto 0); --Input B
		 i_Ainv : in  std_logic;        --Invert A
		 i_Binv : in  std_logic;        --Invert B
		 i_C    : in  std_logic;        --Carry In
		 c_Op   : in  std_logic_vector(2 downto 0); --Operation
		 o_D    : out std_logic_vector(N - 1 downto 0); --Output Result
		 o_OF   : out std_logic;        --Overflow Output
		 o_Zero : out std_logic);       --Zero Output

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
	signal s_Carry, s_Set : std_logic_vector(N - 1 downto 0) := (others => '0');
	signal s_Orout        : std_logic;

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
			     o_D    => o_D(0),
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
				     o_D    => o_D(I),
				     o_C    => s_Carry(I),
				     o_Set  => s_Set(I));
	end generate MSB;

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

end structure;
