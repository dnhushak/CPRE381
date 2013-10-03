library IEEE;
use IEEE.std_logic_1164.all;
use work.arr_32.all;
use IEEE.numeric_std.all;


entity registerfile is
  generic(REGSIZE : integer := 32; NUMREGS : integer :=32);
  port(i_CLK        : in std_logic;     -- Clock input
       i_In         : in std_logic_vector(31 downto 0);		-- Data Input
       i_Wa         : in std_logic_vector(4 downto 0);		-- Write address
       i_We			: in std_logic; 						-- Global Write Enable
       i_R1a        : in std_logic_vector(4 downto 0);		-- Read 1 address
       o_R1o        : out std_logic_vector(31 downto 0);	-- Read 1 Data Output
       i_R2a        : in std_logic_vector(4 downto 0);		-- Read 2 address
       o_R2o        : out std_logic_vector(31 downto 0));	-- Read 2 Data Output

end registerfile;

architecture structure of registerfile is
  
  	component nbitregister
	  generic(N : integer := 32);
	  port(i_CLK        : in std_logic;     -- Clock input
		   i_RST        : in std_logic;     -- Reset input
		   i_WE         : in std_logic;     -- Write enable input
		   i_D          : in std_logic_vector(31 downto 0);     -- Data value input
		   o_Q          : out std_logic_vector(31 downto 0));   -- Data value output
  	end component;
  
  	component decoder5to32
		port(	i_A		:	in std_logic_vector(4 downto 0);
				o_R		:	out std_logic_vector(31 downto 0));
	end component;
	
  	component and2
		port(	i_A          : in std_logic;
			   i_B          : in std_logic;
			   o_F          : out std_logic);
	end component;
  
  	component n32bitmux32to1
		generic(N : integer := 32);
		port(i_C      : in std_logic_vector(4 downto 0);
		   i_X 	: in array32_bit(N-1 downto 0);
		   o_M 	: out std_logic_vector(N-1 downto 0));
  	end component;
  	
  	
  	--Signals
  	
  	--Register Outputs
  	signal s_Reg : array32_bit(31 downto 0);
  	
  	--Decoded Write Address
  	signal s_Wa : std_logic_vector(31 downto 0);
  	
  	--Globaly enabled decoded write address
  	signal s_We : std_logic_vector(31 downto 0);
  	
  	--Reset Signal
  	signal s_Res : std_logic_vector(31 downto 0);
  
begin
	s_Res <= "11111111111111111111111111111111";
	
	--Registers
	gen_registers: for I in 0 to 31 generate
      	g_registers : nbitregister 
      	port map(i_CLK => i_CLK,
	       i_RST => s_Res(I),
	       i_WE => s_We(I),
	       i_D => i_in,
	       o_Q => s_Reg(I));

	end generate gen_registers;
	
	--Ands for global write enable
	gen_ands: for I in 0 to 31 generate
      	g_ands : and2
      	port map(i_A => s_Wa(I),
	       i_B => i_We,
	       o_F => s_We(I));

	end generate gen_ands;
	
	--First read selector
	readmux1: n32bitmux32to1
	port map(i_C => i_R1a,
	   i_X 	=> s_Reg,
	   o_M 	=> o_R1o);
	   
	--Second read selector
	readmux2: n32bitmux32to1
	port map(i_C => i_R2a,
	   i_X 	=> s_Reg,
	   o_M 	=> o_R2o);
	
	--Write address decoder   
	decoder: decoder5to32
	port map(i_A => i_Wa,
	   o_R => s_Wa);
	   
	   
    
  
end structure;
