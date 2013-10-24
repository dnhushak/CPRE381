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
		 i_Op   : in  std_logic_vector(1 downto 0); --Operation
		 o_R    : out std_logic_vector(N - 1 downto 0); --Output Result
		 o_OF   : out std_logic;       --Overflow Output
		 o_Zero	: out std_logic);		--Zero Output

end ALU_Nbit;

architecture structure of ALU_Nbit is
	component ALU_1bit
		port(i_A    : in  std_logic;    --Input A
			 i_B    : in  std_logic;    --Input B
			 i_Ainv : in  std_logic;    --Invert A
			 i_Binv : in  std_logic;    --Invert B
			 i_C    : in  std_logic;    --Carry In
			 i_L    : in  std_logic;    --Input "Less"
			 i_Op   : in  std_logic_vector(1 downto 0); --Operation
			 o_R    : out std_logic;    --Output Result
			 o_C    : out std_logic;    --Carry Out
			 o_S    : out std_logic);   --Set Output
	end component;

	component xor2
		port(i_A : in  std_logic;
			 i_B : in  std_logic;
			 o_F : out std_logic);
	end component;
	
	component or_Nbit 
	generic(N : integer := N);
  		port(i_A          : in std_logic_vector(N - 1 downto 0);
       		o_F          : out std_logic);

		end component;
		
		component inv
				port(i_A : in std_logic;
					o_F  : out std_logic);
			end component;

	-- Signals
	signal s_Carry, s_Set : std_logic_vector(N - 1 downto 0) := (others => '0');
	signal s_Orout :std_logic;

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
			     i_L    => s_Set(N-1),
			     i_Op   => i_Op,
			     o_R    => o_R(0),
			     o_C    => s_Carry(0),
			     o_S    => s_Set(0));

	---------------------------------------------------------
	--MSB's: 1 Bit ALU's								   --
	---------------------------------------------------------
	MSB : for I in 1 to N - 1 generate
		gen_MSB : ALU_1bit
			port map(i_A    => i_A(I),
				     i_B    => i_B(I),
				     i_Ainv => i_Ainv,
				     i_Binv => i_Binv,
				     i_C    => s_Carry(I-1),
				     i_L    => '0',
				     i_Op   => i_Op,
				     o_R    => o_R(I),
				     o_C    => s_Carry(I),
				     o_S    => s_Set(I));
	end generate MSB;

	---------------------------------------------------------
	--LEVEL 2: XOR of Cin(31) and Cout(31) for overflow    --
	---------------------------------------------------------

	OFXOR : xor2
		port map(i_A => s_Carry(N - 1),
			     i_B => s_Carry(N - 2),
			     o_F => o_OF);
			     
	---------------------------------------------------------
	--LEVEL 3: OR of all Adder Outputs for zero output	   --
	---------------------------------------------------------

	ZEROOR : or_Nbit
		generic map (N => N)
		port map(i_A => s_Set,
			     o_F => s_OROUT);
			     
	ZEROINV : inv
		port map (i_A => s_OROUT,
					o_F => o_Zero);

end structure;
