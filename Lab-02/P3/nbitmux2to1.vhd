library IEEE;
use IEEE.std_logic_1164.all;


entity nbitmux2to1 is

  generic(N : integer := 2);
  port(i_C              : in std_logic;
       i_X 		: in std_logic_vector(N-1 downto 0);
       i_Y              : in std_logic_vector(N-1 downto 0);
       o_M 		: out std_logic_vector(N-1 downto 0));

end nbitmux2to1;

architecture structure of nbitmux2to1 is
  
  -- Describe the component entities as defined in Adder.vhd 
  -- and Multiplier.vhd (not strictly necessary).
  component and2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;

  component or2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;
  
  component inv
    port(i_A             : in std_logic;
         o_F             : out std_logic);
  end component;

  -- Signals to store A*x, B*x
  signal sControlInv : std_logic;
  signal sMuxX, sMuxY : std_logic_vector(N-1 downto 0);

begin

  --IF C == 0, THEN X, C == 1, THEN Y
  
  ---------------------------------------------------------------------------
  -- Level 1: Invert Control Signal
  ---------------------------------------------------------------------------
  g_InvertC: inv
    port MAP(i_A               => i_C,
             o_F               => sControlInv);
    
 ---------------------------------------------------------------------------
  -- Level 2: AND X and Y with the control signal (or inverted control signal)
  ---------------------------------------------------------------------------
    gen_gates: for I in 0 to N-1 generate
      	g_MuxX : and2 
      	port map(i_A => i_X(I),
	       i_B => sControlInv,
               o_F => sMuxX(I));
	
	g_MuxY : and2
      	port map(i_A => i_Y(I),
	       i_B => i_C,
               o_F => sMuxY(I));
	
	g_or2 : or2      	
	port map(i_A => sMuxX(I),
	       i_B => sMuxY(I),
               o_F => o_M(I));

    end generate gen_gates;

   
  
end structure;
