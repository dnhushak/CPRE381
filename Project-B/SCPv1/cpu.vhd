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

-- This architecture of CPU must be dominantly structural, with no behavior 
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

	component control is
		port(op_code    : in  m32_6bits;
			 reg_dst    : out m32_1bit;
			 alu_src    : out m32_1bit;
			 mem_to_reg : out m32_1bit;
			 reg_write  : out m32_1bit;
			 mem_read   : out m32_1bit;
			 mem_write  : out m32_1bit;
			 branch     : out m32_1bit;
			 jump       : out m32_1bit;
			 alu_op     : out m32_2bits);
	end component;

	component adder is
		port(src1   : in  m32_word;
			 src2   : in  m32_word;
			 result : out m32_word);
	end component;

	component ALU is
		port(rdata1   : in  m32_word;
			 rdata2   : in  m32_word;
			 alu_code : in  m32_4bits;
			 result   : out m32_word;
			 zero     : out m32_1bit);
	end component;

	component reg is
		generic(M : integer := 32);     -- Size of the register
		port(D     : in  m32_vector(M - 1 downto 0); -- Data input
			 Q     : out m32_vector(M - 1 downto 0); -- Data output
			 WE    : in  m32_1bit;      -- Write enableenable
			 reset : in  m32_1bit;      -- The clock signal
			 clock : in  m32_1bit);     -- The reset signal
	end component;

	component alucontrol is
		port(i_op      : in  m32_2bits; -- ALUop out of control
			 i_funct   : in  m32_6bits; -- Bits 0-5 of the instruction word
			 o_alucont : out m32_4bits); -- Output that determines ALU operation
	end component;

	-- 2-to-1 MUX
	component mux2to1 is
		generic(M : integer := 1);      -- Number of bits in the inputs and output
		port(input0 : in  m32_vector(M - 1 downto 0);
			 input1 : in  m32_vector(M - 1 downto 0);
			 sel    : in  m32_1bit;
			 output : out m32_vector(M - 1 downto 0));
	end component;

	component extender_Nbit_Mbit is
		generic(N : integer := 8;
			    M : integer := 32);
		port(i_C : in  std_logic;       --Control Input (0 is zero exnension, 1 is sign extension)
			 i_N : in  std_logic_vector(N - 1 downto 0); --N-bit Input
			 o_W : out std_logic_vector(M - 1 downto 0)); --Full Word Output
	end component;

	component barrelshift is
		generic(N : integer := 31);
		port(i_A   : in  std_logic_vector(N - 1 downto 0); -- input to shift
			 i_S   : in  std_logic_vector(4 downto 0); -- amount to shift by
			 i_FS  : in  std_logic;     -- select signal for flipping input
			 i_Ext : in  std_logic;     -- determines whether to fill front end with 1 or 0 (always 0 when left shift)
			 o_F   : out std_logic_vector(N - 1 downto 0)); -- shifted output

	end component;

	--
	-- Signals in the CPU
	--PC Signals
	signal PC, PCUpdate, branchaddressX4, branchaddress, extended, PCPlus4, jumpaddress, jumpinstruction, jumpinstructionX4, nojumpaddress : m32_word;

	-- Control signals
	signal regdst, jump, branch, memread, memtoreg, memwrite, alusrc, regwrite, zero, beq : m32_1bit;
	signal aluop                                                                          : m32_2bits;
	signal s_alucontrol                                                                   : m32_4bits;

	--Data
	signal instruction, read1, read2, aluresult, memorydataread, registerwrite, alumux : m32_word;
	signal writemux                                                                    : m32_5bits;

	--Clock
	signal CLK : m32_logic;
begin
	CLK <= clock;
	-----------------------------------------------------------
	--Instruction I/O
	-----------------------------------------------------------
	PCREG : reg
		generic map(M => 32)            -- Size of the register
		port map(D     => PCUpdate,     -- Data input
			     Q     => PC,           -- Data output
			     WE    => '1',          -- Write enableenable
			     reset => reset,        -- The clock signal
			     clock => clock);       -- The reset signal

	imem_addr   <= PC;
	instruction <= inst;

	-----------------------------------------------------------
	--Register I/O
	-----------------------------------------------------------
	WRITESWITCHER : mux2to1
		generic map(M => 5)
		port map(sel    => regdst,
			     input0 => instruction(20 downto 16),
			     input1 => instruction(15 downto 11),
			     output => writemux);

	REGISTERS : regfile port map(src1   => instruction(25 downto 21),
			                     src2   => instruction(20 downto 16),
			                     dst    => writemux,
			                     wdata  => registerwrite,
			                     rdata1 => read1,
			                     rdata2 => read2,
			                     WE     => regwrite,
			                     reset  => reset,
			                     clock  => CLK);

	-----------------------------------------------------------
	--ALU I/O
	-----------------------------------------------------------
	MASTERALU : ALU
		port map(rdata1   => read1,
			     rdata2   => alumux,
			     alu_code => s_alucontrol,
			     result   => aluresult,
			     zero     => zero);

	ALUSWITCHER : mux2to1
		generic map(M => 32)
		port map(sel    => alusrc,
			     input0 => read2,
			     input1 => extended,
			     output => alumux);

	EXTENSION : extender_Nbit_Mbit
		generic map(N => 16, M => 32)
		port map(i_C => '1',
			     i_N => instruction(15 downto 0),
			     o_W => extended);

	ALUCONTROLLER : alucontrol
		port map(i_op      => aluop,
			     i_funct   => instruction(5 downto 0),
			     o_alucont => s_alucontrol);

	-----------------------------------------------------------
	--Control I/O
	-----------------------------------------------------------   

	CONTROLLER : control port map(op_code    => instruction(31 downto 26),
			                      reg_dst    => regdst,
			                      alu_src    => alusrc,
			                      mem_to_reg => memtoreg,
			                      reg_write  => regwrite,
			                      mem_read   => memread,
			                      mem_write  => memwrite,
			                      branch     => branch,
			                      jump       => jump,
			                      alu_op     => aluop);

	-----------------------------------------------------------
	--Memory I/O
	-----------------------------------------------------------   

	-------FIX BYTE VS WORD ADDRESS------
	dmem_addr      <= aluresult;
	dmem_read      <= memread;
	dmem_write     <= memwrite;
	dmem_wmask     <= "1111";           -- Data memory write mask
	memorydataread <= dmem_rdata;
	dmem_wdata     <= read2;

	-----------------------------------------------------------
	--Writeback
	-----------------------------------------------------------   
	WRITEBACKSWITCHER : mux2to1 generic map(M => 32) port map(sel => memtoreg,
			input0 => aluresult,
			input1 => memorydataread,
			output => registerwrite);

	-----------------------------------------------------------
	--PC Logic
	-----------------------------------------------------------  

	--Add four to PC 
	PCADDFOUR : adder
		port map(src1   => PC,
			     src2   => X"00000004",
			     result => PCPlus4);

	BRANCHSHIFTER : barrelshift
		generic map(N => 31)
		port map(i_A   => extended,
			     i_S   => "00010",
			     i_FS  => '0',
			     i_Ext => '0',
			     o_F   => branchaddressX4);

	--Add PC +4 to multiplied relative Branch Address to get absolute PC address
	BRANCHADDER : adder
		port map(src1   => PCPlus4,
			     src2   => branchaddressX4,
			     result => branchaddress);

	--AND branch and zero for BEQ
	beq <= branch and zero;

	--Switch between PC + 4 and branch address (the result here called nojumpaddress)
	BRANCHSWITCHER : mux2to1
		generic map(M => 32)
		port map(sel    => beq,
			     input0 => PCPlus4,
			     input1 => branchaddress,
			     output => nojumpaddress);

	jumpinstruction <= "000000" & instruction(25 downto 0);

	INSTRUCTIONSHIFTER : barrelshift
		generic map(N => 31)
		port map(i_A   => jumpinstruction,
			     i_S   => "00010",
			     i_FS  => '0',
			     i_Ext => '0',
			     o_F   => jumpinstructionX4);

	jumpaddress <= PCPlus4(31 downto 28) & jumpinstructionX4(27 downto 0);

	--Switch between jump address and non-jump address
	JUMPSWITCHER : mux2to1
		generic map(M => 32)
		port map(sel    => jump,
			     input0 => nojumpaddress,
			     input1 => jumpaddress,
			     output => PCUpdate);
end structure;

