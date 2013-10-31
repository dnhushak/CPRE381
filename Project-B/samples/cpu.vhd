-- cpu.vhd: Single-cycle implementation of MIPS32 for CprE 381, fall 2013,
-- Iowa State University
--
-- Zhao Zhang, fall 2013

-- The CPU entity. It connects to 1) an instruction memory, 2) a data memory, and 
-- 3) an external clock source.
--
-- Note: This is a partical sample
--

library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;
use work.utils.all;
use IEEE.numeric_std.all;

entity cpu is
	port(imem_addr  : out m32_word;     -- Instruction memory address
		 inst       : in  m32_word;     -- Instruction
		 dmem_addr  : out m32_word;     -- Data memory address
		 dmem_read  : out m32_1bit;     -- Data memory read?
		 dmem_write : out m32_1bit;     -- Data memory write?
		 dmem_wmask : out m32_4bits;    -- Data memory write mask
		 dmem_rdata : in  m32_word;     -- Data memory read data
		 dmem_wdata : out m32_word;     -- Data memory write data
		 reset      : in  m32_1bit;     -- Reset signal
		 clock      : in  m32_1bit);    -- System clock
end cpu;

-- This architecture of CPU must be dominantly structural, with no bahavior 
-- modeling, and only data flow statements to copy/split/merge signals or 
-- with a single level of basic logic gates.
architecture structure of cpu is
	-- More code here

	-- The register file
	component regfile is
		port(src1   : in  m32_5bits;
			 src2   : in  m32_5bits;
			 dst    : in  m32_5bits;
			 wdata  : in  m32_word;
			 rdata1 : out m32_word;
			 rdata2 : out m32_word;
			 WE     : in  m32_1bit;
			 reset  : in  m32_1bit;
			 clock  : in  m32_1bit);
	end component;

	-- 2-to-1 MUX
	component mux_Nbit_Min is
		generic(N : integer := 32;
			    M : integer := 2;
			    A : integer := 1);      -- Number of bits in the inputs and output
		port (i_C : in  std_logic_vector(A - 1 downto 0);
			 --When declaring, M is the input port, N is the bit of that input port
			 i_X       : in  array_Nbit(M - 1 downto 0, N - 1 downto 0);
			 o_M       : out std_logic_vector(N - 1 downto 0));
	end component;

	--
	-- Signals in the CPU
	--

	-- PC-related signals
	signal PC : m32_word;               -- PC for the current inst
	-- More code here

	-- Instruction fields and derives
	signal opcode : m32_6bits;          -- 6-bit opcode
	-- More code here

	-- Control signals
	signal reg_dst : m32_1bit;          -- Register destination
	-- More code here

	-- Other non-control signals connected to regfile
	-- More code here
	signal wdata : m32_word;            -- Register write data

-- More code here

begin
	-- More code here

	-- Jump target
	j_target <= PC(31 downto 28) & j_offset & "00";

	-- More code here

	-- Split the instructions into fields
	SPLIT : block
	begin
		opcode <= inst(31 downto 26);
	-- More code here
	end block;

	-- The mux connected to the dst port of regfile
	DST_MUX : mux2to1 generic map(M => 5)
		port map(rt, rd, reg_dst, dst);

	-- The register file
	REGFILE1 : regfile
		port map(rs, rt, dst,           -- more code here);

	             -- More code here

	             end structure;

