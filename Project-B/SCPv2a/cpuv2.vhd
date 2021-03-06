--Done:
--bne
-- Muxing around the branch logic, need to make the branch control 2 bits
--slti
-- Changing of control unit to output 1 for alu_src on the correct function code of addi
--addi
-- Changing of control unit to output 1 for alu_src on the correct function code of addi
--jal
-- standard jump but also need to write back to the $ra register from the PC + 4 signal
--jr
-- standard jump, but from a register
--sll
-- Edit ALU to have magic shifter (sll, srl, and sla) in it, edit control and alu control to output correct opcode to select that
-- Also have to have mux at the input of ALU in A for shift amount

library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;

entity cpuv2 is
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
end cpuv2;

-- This architecture of cpuv2 must be dominantly structural, with no behavior 
-- modeling, and only data flow statements to copy/split/merge signals or 
-- with a single level of basic logic gates.
architecture structure of cpuv2 is
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

	component controlv2 is
		port(op_code    : in  m32_6bits;
			 reg_dst    : out m32_1bit;
			 alu_src    : out m32_1bit;
			 mem_to_reg : out m32_1bit;
			 reg_write  : out m32_1bit;
			 mem_read   : out m32_1bit;
			 mem_write  : out m32_1bit;
			 branch     : out m32_2bits;
			 alu_op     : out m32_2bits;
			 jump       : out m32_1bit;
			 jal        : out m32_1bit);
	end component;

	component adder is
		port(src1   : in  m32_word;
			 src2   : in  m32_word;
			 result : out m32_word);
	end component;

	component ALUv2 is
		port(rdata1   : in  m32_word;
			 rdata2   : in  m32_word;
			 alu_code : in  m32_5bits;
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

	component alucontrolv2 is
		port(i_op      : in  m32_2bits; -- ALUv2op out of control
			 i_funct   : in  m32_6bits; -- Bits 0-5 of the instruction word
			 o_jr      : out m32_1bit;  -- JR Control signal (Has to be handled here because JR is an R type instruction
			 o_shift   : out m32_1bit;  --select input A to be shamt
			 o_alucont : out m32_5bits); -- Output that determines ALUv2 operation
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
	-- Signals in the cpuv2
	--PC Signals
	signal PC, PCUpdate, jumporbranch, branchaddressX4, branchaddress, extended, PCPlus4, jumpaddress, jumpinstruction, jumpinstructionX4, nojumpaddress : m32_word;

	-- Control signals
	signal regdst, jump, memread, memtoreg, memwrite, alusrc, regwrite, zero, beq, one, bne, takebranch, jalselect, jrselect, shiftselect : m32_1bit;
	signal aluop, branch                                                                                                                  : m32_2bits;
	signal s_alucontrol                                                                                                                   : m32_5bits;

	--Data
	signal instruction, read1, read2, aluresult, memorydataread, registerwrite, shamt, alumux1, alumux2, writeback : m32_word;
	signal writemux, regwritedst                                                                                   : m32_5bits;

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

	-- Write to return address register ($31 or $ra) for jal
	JALSWITCHER : mux2to1
		generic map(M => 5)
		port map(sel    => jalselect,
			     input0 => writemux,
			     input1 => "11111",
			     output => regwritedst);

	-- Select return address for writing for jalselect
	WADDRESSSWITCHER : mux2to1
		generic map(M => 32)
		port map(sel    => jalselect,
			     input0 => writeback,
			     input1 => PCPlus4,
			     output => registerwrite);

	REGISTERS : regfile port map(src1   => instruction(25 downto 21),
			                     src2   => instruction(20 downto 16),
			                     dst    => regwritedst,
			                     wdata  => registerwrite,
			                     rdata1 => read1,
			                     rdata2 => read2,
			                     WE     => regwrite,
			                     reset  => reset,
			                     clock  => CLK);

	-----------------------------------------------------------
	--ALUv2 I/O
	-----------------------------------------------------------

	SHAMTEXTENDER : extender_Nbit_Mbit
		generic map(N => 5, M => 32)
		port map(i_C => '1',
			     i_N => instruction(10 downto 6),
			     o_W => shamt);

	MASTERALUv2 : ALUv2
		port map(rdata1   => alumux1,
			     rdata2   => alumux2,
			     alu_code => s_alucontrol,
			     result   => aluresult,
			     zero     => zero);

	ALUSWITCHER1 : mux2to1
		generic map(M => 32)
		port map(sel    => shiftselect,
			     input0 => read1,
			     input1 => shamt,
			     output => alumux1);

	ALUSWITCHER2 : mux2to1
		generic map(M => 32)
		port map(sel    => alusrc,
			     input0 => read2,
			     input1 => extended,
			     output => alumux2);

	-- Extension is for branching and immediate loading into ALUv2
	EXTENSION : extender_Nbit_Mbit
		generic map(N => 16, M => 32)
		port map(i_C => '1',
			     i_N => instruction(15 downto 0),
			     o_W => extended);

	ALUCONTROLLER : alucontrolv2
		port map(i_op      => aluop,
			     i_funct   => instruction(5 downto 0),
			     o_jr      => jrselect,
			     o_shift   => shiftselect,
			     o_alucont => s_alucontrol);

	-----------------------------------------------------------
	--Control I/O
	-----------------------------------------------------------   

	CONTROLLER : controlv2 port map(op_code    => instruction(31 downto 26),
			                      reg_dst    => regdst,
			                      alu_src    => alusrc,
			                      mem_to_reg => memtoreg,
			                      reg_write  => regwrite,
			                      mem_read   => memread,
			                      mem_write  => memwrite,
			                      branch     => branch,
			                      alu_op     => aluop,
			                      jump       => jump,
			                      jal        => jalselect);

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
			output => writeback);

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

	--AND branch and zero for BEQ, AND branch and not(zero) for bne
	beq        <= branch(0) and zero;
	one        <= not zero;
	bne        <= branch(1) and one;
	takebranch <= beq or bne;

	--Switch between PC + 4 and branch address (the result here called nojumpaddress)
	BRANCHSWITCHER : mux2to1
		generic map(M => 32)
		port map(sel    => takebranch,
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
			     output => jumporbranch);

	--Switch between previous addresses or register address for jump
	JRSWITCHER : mux2to1
		generic map(M => 32)
		port map(sel    => jrselect,
			     input0 => jumporbranch,
			     input1 => aluresult,
			     output => PCUpdate);
end structure;

