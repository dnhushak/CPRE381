library IEEE;
use IEEE.std_logic_1164.all;


entity fulladder_1bit is

  port(i_A      : in std_logic;
       i_B 		: in std_logic;
       i_C      : in std_logic;
       o_S 		: out std_logic;
       o_C		: out std_logic);

end fulladder_1bit;

architecture structure of fulladder_1bit is
  
  -- Describe the component entities as defined in Adder.vhd 
  -- and Multiplier.vhd (not strictly necessary).
  component and2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;

  component xor2
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         o_F             : out std_logic);
  end component;

  component or3
    port(i_A             : in std_logic;
         i_B             : in std_logic;
         i_C             : in std_logic;
         o_F             : out std_logic);
  end component;
  
  -- Signals
  signal sAxorB, sAandB, sAandC, sBandC : std_logic;

begin


  ---------------------------------------------------------------------------
  -- Level 1: XOR A and B; AND A,B; A,C; B,C
  ---------------------------------------------------------------------------
  g_xorAB: xor2
    port MAP(i_A               => i_A,
   	     i_B               => i_B,
             o_F               => sAxorB);
             
  g_andAB: and2
    port MAP(i_A              => i_A,
             i_B              => i_B,
             o_F              => sAandB);

  g_andAC: and2
    port MAP(i_A              => i_A,
             i_B              => i_C,
             o_F              => sAandC);

  g_andBC: and2
    port MAP(i_A              => i_B,
             i_B              => i_C,
             o_F              => sBandC);
    
 ---------------------------------------------------------------------------
  -- Level 2: XOR with Control signal, OR all the AND results
  ---------------------------------------------------------------------------
  g_xorCarry: xor2
    port MAP(i_A              => sAxorB,
             i_B              => i_C,
             o_F              => o_S);

  g_or3: or3
    port MAP(i_A              => sAandB,
             i_B              => sAandC,
             i_C              => sBandC,
             o_F              => o_C);

    
  
end structure;
