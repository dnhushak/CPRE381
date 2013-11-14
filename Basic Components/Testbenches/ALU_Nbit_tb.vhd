library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_Nbit_tb is
	generic(BITS : integer := 6);
	constant WAITTIME : time := 10 ns;
end ALU_Nbit_tb;

architecture behavior of ALU_Nbit_tb is
	component ALU_Nbit
		generic(N : integer := BITS);
		port(i_A    : in  std_logic_vector(N - 1 downto 0); --Input A
			 i_B    : in  std_logic_vector(N - 1 downto 0); --Input B
			 i_Ainv : in  std_logic;    --Invert A
			 i_Binv : in  std_logic;    --Invert B
			 i_C    : in  std_logic;    --Carry In
			 c_Op   : in  std_logic_vector(2 downto 0); --Operation
			 o_D    : out std_logic_vector(N - 1 downto 0); --Output Result
			 o_OF   : out std_logic;    --Overflow Output
			 o_Zero : out std_logic);   --Zero Output

	end component;

	signal s_A, s_B, s_O : std_logic_vector(BITS - 1 downto 0) := (others => '0');
	signal s_Op          : std_logic_vector(4 downto 0);
	signal s_OF, s_Zero  : std_logic;


-- Op Code:
-- MUX MUX MUX BINV AINV

-- Opcodes:
-- 00000 AND
-- 00001 OR
-- 00010 ADD
-- 01010 SUB
-- 01011 SLT
-- 11000 NOR
-- 11001 NAND
-- 00100 XOR
-- Ainv, Binv & Cin, Mux(1), Mux(0)

begin
	ALU : ALU_Nbit
		port map(i_A    => s_A,
			     i_B    => s_B,
			     i_Ainv => s_Op(4),
			     i_Binv => s_Op(3),
			     i_C    => s_Op(3),
			     c_Op   => s_Op(2 downto 0),
			     o_D    => s_O,
			     o_OF   => s_OF,
			     o_Zero => s_Zero);

	process
	begin

		--Add 
		s_Op <= "00010";
		s_A  <= "000010";
		s_B  <= "000000";
		wait for WAITTIME;

		--Sub 
		s_Op <= "01010";
		wait for WAITTIME;

		--Slt 
		s_Op <= "01011";
		wait for WAITTIME;

		--Add 
		s_Op <= "00010";
		s_A  <= "000010";
		s_B  <= "000001";
		wait for WAITTIME;

		--Sub 
		s_Op <= "01010";
		wait for WAITTIME;

		--Slt 
		s_Op <= "01011";
		wait for WAITTIME;

		--Add 
		s_Op <= "00010";
		s_A  <= "000010";
		s_B  <= "000011";
		wait for WAITTIME;

		--Sub 
		s_Op <= "01010";
		wait for WAITTIME;

		--Slt 
		s_Op <= "01011";
		wait for WAITTIME;

		--Add 
		s_Op <= "00010";
		s_A  <= "000010";
		s_B  <= "000111";
		wait for WAITTIME;

		--Sub 
		s_Op <= "01010";
		wait for WAITTIME;

		--Slt 
		s_Op <= "01011";
		wait for WAITTIME;

		--Visual break
		s_Op <= "00010";
		s_A  <= "000000";
		s_B  <= "000000";
		wait for 100 ns;

		--Overflow check
		s_Op <= "00010";
		s_A  <= "011111";
		s_B  <= "000001";
		wait for WAITTIME;

		--Visual break
		s_Op <= "00010";
		s_A  <= "000000";
		s_B  <= "000000";
		wait for 100 ns;

		--AND, OR, XOR, NAND, NOR

		s_A <= "000011";
		s_B <= "000000";

		s_Op <= "00000";
		wait for WAITTIME;
		s_Op <= "00001";
		wait for WAITTIME;
		s_Op <= "00100";
		wait for WAITTIME;
		s_Op <= "11001";
		wait for WAITTIME;
		s_Op <= "11000";
		wait for WAITTIME;

		s_A <= "000011";
		s_B <= "000001";

		s_Op <= "00000";
		wait for WAITTIME;
		s_Op <= "00001";
		wait for WAITTIME;
		s_Op <= "00100";
		wait for WAITTIME;
		s_Op <= "11001";
		wait for WAITTIME;
		s_Op <= "11000";
		wait for WAITTIME;

		s_A <= "000011";
		s_B <= "000010";

		s_Op <= "00000";
		wait for WAITTIME;
		s_Op <= "00001";
		wait for WAITTIME;
		s_Op <= "00100";
		wait for WAITTIME;
		s_Op <= "11001";
		wait for WAITTIME;
		s_Op <= "11000";
		wait for WAITTIME;

		s_A <= "000011";
		s_B <= "000011";

		s_Op <= "00000";
		wait for WAITTIME;
		s_Op <= "00001";
		wait for WAITTIME;
		s_Op <= "00100";
		wait for WAITTIME;
		s_Op <= "11001";
		wait for WAITTIME;
		s_Op <= "11000";
		wait for WAITTIME;

		--Visual break
		s_Op <= "00010";
		s_A  <= "000000";
		s_B  <= "000000";
		wait for 100 ns;

	end process;
end behavior;
