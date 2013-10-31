library IEEE;
use IEEE.std_logic_1164.all;


entity mux_1bit_2in is

  port(i_C      : in std_logic;
       i_X 		: in std_logic;
       i_Y      : in std_logic;
       o_M 		: out std_logic);

end mux_1bit_2in;

architecture structure of mux_1bit_2in is
  
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
  signal sControlInv, sMuxX, sMuxY : std_logic;

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
  g_MuxX: and2
    port MAP(i_A              => i_X,
             i_B              => sControlInv,
             o_F              => sMuxX);

  g_MuxY: and2
    port MAP(i_A              => i_Y,
             i_B              => i_C,
             o_F              => sMuxY);

    
  ---------------------------------------------------------------------------
  -- Level 3: OR the Mux'ed signals together
  ---------------------------------------------------------------------------
   g_or2: or2
    port MAP(i_A              => sMuxX,
             i_B              => sMuxY,
             o_F              => o_M);
  
end structure;
