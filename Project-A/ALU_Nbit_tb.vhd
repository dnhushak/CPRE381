library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ALU_Nbit_tb is
	generic(BITS : integer :=6);
end ALU_Nbit_tb;

architecture behavior of ALU_Nbit_tb is


-- Declare the component we are going to instantiate



component ALU_Nbit	
	generic(N : integer := BITS);
	port(i_A    : in  std_logic_vector(N - 1 downto 0); --Input A
		 i_B    : in  std_logic_vector(N - 1 downto 0); --Input B
		 i_Ainv : in  std_logic;        --Invert A
		 i_Binv : in  std_logic;        --Invert B
		 i_C    : in  std_logic;        --Carry In
		 i_Op   : in  std_logic_vector(1 downto 0); --Operation
		 o_R    : out std_logic_vector(N - 1 downto 0); --Output Result
		 o_OF   : out std_logic;       --Overflow Output
		 o_Zero : out std_logic);		--Zero Output

end component;


signal s_A, s_B, s_O, : std_logic_vector(BITS - 1  downto 0) := (others =>'0');
signal s_Op : std_logic_vector(3 downto 0);

-- Opcodes:
-- 0000 AND
-- 0001 OR
-- 0010 ADD
-- 0110 SUB
-- 0111 SLT
-- 1100 NOR
-- Ainv, Binv & Cin, Mux(1), Mux(0)

begin
            
ALU_Nbit: ALU_Nbit
  port map( i_A  => s_A,
  			i_B  => s_B,
  			i_Ainv  => s_Op(3),
  			i_Binv  => s_Op(2),
  			i_C  => s_Op(2),
  			i_Op  => s_Op(1 downto 0),
            o_R  => s_O);
            
			
			
  process
  begin
	--Initialize
	for I in 0 to INBITS - 1  loop
     	 s_Encoded(I) <= '0';
    	end loop;
    wait for 10 ns;
    
	--Increment the Encoded signal by 1 every 10 ns
    for I in 0 to OUTBITS - 1 loop
		s_Encoded <= std_logic_vector( unsigned(s_Encoded) + 1);
		wait for 10 ns;
    end loop;


end process;
end behavior;
