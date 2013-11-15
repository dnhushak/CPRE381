library IEEE;
use IEEE.std_logic_1164.all;
use work.mips32.all;

entity cpuv3 is
	-- Use N to change the global bit width of the CPU, A should change with it such that 2^A = N
	-- 64 bit MIPS processor? I think I should get some extra points =D
	generic(N : integer := 32;
		    A : integer := 5);
	port(imem_addr  : out m32_vector(N - 1 downto 0); -- Instruction memory address
		 inst       : in  m32_vector(N - 1 downto 0); -- Instruction
		 dmem_addr  : out m32_vector(N - 1 downto 0); -- Data memory address
		 dmem_read  : out m32_1bit;     -- Data memory read?
		 dmem_write : out m32_1bit;     -- Data memory write?
		 dmem_wmask : out m32_4bits;    -- Data memory write mask
		 dmem_rdata : in  m32_vector(N - 1 downto 0); -- Data memory read data
		 dmem_wdata : out m32_vector(N - 1 downto 0); -- Data memory write data
		 reset      : in  m32_1bit;     -- Reset signal
		 clock      : in  m32_1bit);    -- System clock
end cpuv3;

architecture structure of cpuv3 is
	component registerfile_Nbit_Mreg is
		-- N is size of register, M is number of registers (MUST be power of 2), A is size of register addresses (A MUST equal log2(M))
		generic(N : integer := N;
			    M : integer := 32;
			    A : integer := 5);
		port(c_CLK : in  m32_1bit;      -- Clock input
			 i_A   : in  m32_vector(N - 1 downto 0); -- Data Input
			 i_Wa  : in  m32_vector(A - 1 downto 0); -- Write address
			 c_WE  : in  m32_1bit;      -- Global Write Enable
			 c_RST : in  m32_vector(M - 1 downto 0); -- Register Reset vector
			 i_R1a : in  m32_vector(A - 1 downto 0); -- Read 1 address
			 o_D1o : out m32_vector(N - 1 downto 0); -- Read 1 Data Output
			 i_R2a : in  m32_vector(A - 1 downto 0); -- Read 2 address
			 o_D2o : out m32_vector(N - 1 downto 0)); -- Read 2 Data Output
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

	component fulladder_Nbit is
		generic(N : integer := N);
		port(i_A : in  m32_vector(N - 1 downto 0);
			 i_B : in  m32_vector(N - 1 downto 0);
			 i_C : in  m32_1bit;
			 o_D : out m32_vector(N - 1 downto 0);
			 o_C : out m32_1bit);
	end component;

	component ALU_Nbit is
		generic(N : integer := N);
		port(i_A    : in  m32_vector(N - 1 downto 0); --Input A
			 i_B    : in  m32_vector(N - 1 downto 0); --Input B
			 i_Ainv : in  m32_1bit;     --Invert A
			 i_Binv : in  m32_1bit;     --Invert B
			 i_C    : in  m32_1bit;     --Carry In
			 c_Op   : in  m32_vector(2 downto 0); --Operation
			 o_D    : out m32_vector(N - 1 downto 0); --Output Result
			 o_OF   : out m32_1bit;     --Overflow Output
			 o_Zero : out m32_1bit);    --Zero Output
	end component;

	component register_Nbit is
		generic(N : integer := N);      -- Size of the register
		port(c_CLK : in  m32_1bit;      -- Clock
			 c_RST : in  m32_1bit;      -- Reset
			 c_WE  : in  m32_1bit;      -- Write enable
			 i_A   : in  m32_vector(N - 1 downto 0); -- Input
			 o_D   : out m32_vector(N - 1 downto 0)); -- Output
	end component;

	component alucontrolv2 is
		port(i_op      : in  m32_2bits; -- ALUv2op out of control
			 i_funct   : in  m32_6bits; -- Bits 0-5 of the instruction word
			 o_jr      : out m32_1bit;  -- JR Control signal (Has to be handled here because JR is an R type instruction
			 o_shift   : out m32_1bit;  --select input A to be shamt
			 o_alucont : out m32_5bits); -- Output that determines ALUv2 operation
	end component;

	component mux_Nbit_2in is
		generic(N : integer := 1);      -- Number of bits in the inputs and output
		port(c_S : in  m32_1bit;
			 i_A : in  m32_vector(N - 1 downto 0);
			 i_B : in  m32_vector(N - 1 downto 0);
			 o_D : out m32_vector(N - 1 downto 0));
	end component;

	component extender_Nbit_Mbit is
		generic(N : integer := 8;
			    M : integer := N);
		port(c_Ext : in  m32_1bit;      --Control Input (0 is zero extension, 1 is sign extension)
			 i_A   : in  m32_vector(N - 1 downto 0); --N-bit Input
			 o_D   : out m32_vector(M - 1 downto 0)); --Full Word Output
	end component;

	component leftshifter_Nbit is
		generic(N : integer := N;
			    A : integer := A);
		port(i_A     : in  m32_vector(N - 1 downto 0); -- input to shift
			 c_Shamt : in  m32_vector(A - 1 downto 0); -- amount to shift by
			 o_D     : out m32_vector(N - 1 downto 0)); -- shifted output

	end component;

	-- PC Signals
	signal PC, PCUpdate, jumporbranch, branchaddressX4, branchaddress, extended, PCPlus4, jumpaddress, jumpinstruction, jumpinstructionX4, nojumpaddress : m32_vector(N - 1 downto 0);

	-- Control signals
	signal regdst, jump, memread, memtoreg, memwrite, alusrc, regwrite, zero, beq, one, bne, takebranch, jalselect, jrselect, shiftselect : m32_1bit;
	signal aluop, branch                                                                                                                  : m32_2bits;
	signal s_alucontrol                                                                                                                   : m32_5bits;

	--Data
	signal instruction, read1, read2, aluresult, memorydataread, registerwrite, shamt, alumux1, alumux2, writeback : m32_vector(N - 1 downto 0);
	signal writemux, regwritedst                                                                                   : m32_5bits;

	--Clock
	signal CLK : m32_logic;
begin
	CLK <= clock;
	-----------------------------------------------------------
	--Instruction I/O
	-----------------------------------------------------------
	PCREG : register_Nbit
		generic map(N => N)             -- Size of the register
		port map(i_A   => PCUpdate,     -- Data input
			     o_D   => PC,           -- Data output
			     c_WE  => '1',          -- Write enable
			     c_RST => reset,        -- The clock signal
			     c_CLK => clock);       -- The reset signal

	imem_addr   <= PC;
	instruction <= inst;

	-----------------------------------------------------------
	--Register I/O
	-----------------------------------------------------------

	WRITESWITCHER : mux_Nbit_2in
		generic map(N => 5)
		port map(c_S => regdst,
			     i_A => instruction(20 downto 16),
			     i_B => instruction(15 downto 11),
			     o_D => writemux);

	-- Write to return address register ($31 or $ra) for jal
	JALSWITCHER : mux_Nbit_2in
		generic map(N => 5)
		port map(c_S => jalselect,
			     i_A => writemux,
			     i_B => "11111",
			     o_D => regwritedst);

	-- Select return address for writing for jalselect
	WADDRESSSWITCHER : mux_Nbit_2in
		generic map(N => N)
		port map(c_S => jalselect,
			     i_A => writeback,
			     i_B => PCPlus4,
			     o_D => registerwrite);

	REGISTERS : registerfile_Nbit_Mreg
		generic map(N => N,
			        M => 32,
			        A => 5)
		port map(i_R1a                 => instruction(25 downto 21),
			     i_R2a                 => instruction(20 downto 16),
			     i_Wa                  => regwritedst,
			     i_A                   => registerwrite,
			     o_D1o                 => read1,
			     o_D2o                 => read2,
			     c_WE                  => regwrite,
			     c_RST(N - 1 downto 1) => reset,
			     c_RST(0)              => '1',
			     c_CLK                 => CLK);

	-----------------------------------------------------------
	--ALUv2 I/O
	-----------------------------------------------------------

	SHAMTEXTENDER : extender_Nbit_Mbit
		generic map(N => 5,
			        M => N)
		port map(c_Ext => '1',
			     i_A   => instruction(10 downto 6),
			     o_D   => shamt);

	-- ALU Op is: Mux(2), Ainv, Binv & Cin, Mux(1), Mux(0)
	MASTERALUv2 : ALU_Nbit
		generic map(N => N)
		port map(i_A    => alumux1,
			     i_B    => alumux2,
			     i_Ainv => s_alucontrol(3),
			     i_Binv => s_alucontrol(2),
			     i_C    => s_alucontrol(2),
			     c_Op   => s_alucontrol(4) & s_alucontrol(1 downto 0),
			     o_D    => aluresult,
			     o_OF   => "unused",
			     o_Zero => zero);

	ALUSWITCHER1 : mux_Nbit_2in
		generic map(N => N)
		port map(c_S => shiftselect,
			     i_A => read1,
			     i_B => shamt,
			     o_D => alumux1);

	ALUSWITCHER2 : mux_Nbit_2in
		generic map(N => N)
		port map(c_S => alusrc,
			     i_A => read2,
			     i_B => extended,
			     o_D => alumux2);

	-- Extension is for branching and immediate loading into ALUv2
	EXTENSION : extender_Nbit_Mbit
		generic map(N => 16, M => N)
		port map(c_Ext => '1',
			     i_A   => instruction(15 downto 0),
			     o_D   => extended);

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
	WRITEBACKSWITCHER : mux_Nbit_2in
		generic map(N => 32)
		port map(c_S => memtoreg,
			     i_A => aluresult,
			     i_B => memorydataread,
			     o_D => writeback);

	-----------------------------------------------------------
	--PC Logic
	-----------------------------------------------------------  

	--Add four to PC 
	PCADDFOUR : fulladder_Nbit
		generic map(N => N)
		port map(i_A => PC,
			     i_B => X"00000004",
			     i_C => '0',
			     o_D => PCPlus4,
			     o_C => "unused");

	BRANCHSHIFTER : leftshifter_Nbit
		generic map(N => N,
			        A => A)
		port map(i_A     => extended,
			     c_Shamt => "00010",
			     o_D     => branchaddressX4);

	--Add PC +4 to multiplied relative Branch Address to get absolute PC address
	BRANCHADDER : fulladder_Nbit
		generic map(N => N)
		port map(i_A => PCPlus4,
			     i_B => branchaddressX4,
			     i_C => '0',
			     o_D => branchaddress,
			     o_C => "unused");

	--AND branch and zero for BEQ, AND branch and not(zero) for bne
	beq        <= branch(0) and zero;
	one        <= not zero;
	bne        <= branch(1) and one;
	takebranch <= beq or bne;

	--Switch between PC + 4 and branch address (the result here called nojumpaddress)
	BRANCHSWITCHER : mux_Nbit_2in
		generic map(N => N)
		port map(c_S => takebranch,
			     i_A => PCPlus4,
			     i_B => branchaddress,
			     o_D => nojumpaddress);

	jumpinstruction <= "000000" & instruction(25 downto 0);

	INSTRUCTIONSHIFTER : leftshifter_Nbit
		generic map(N => N,
			        A => A)
		port map(i_A     => jumpinstruction,
			     c_Shamt => "00010",
			     o_D     => jumpinstructionX4);

	jumpaddress <= PCPlus4(31 downto 28) & jumpinstructionX4(27 downto 0);

	--Switch between jump address and non-jump address
	JUMPSWITCHER : mux_Nbit_2in
		generic map(N => N)
		port map(c_S => jump,
			     i_A => nojumpaddress,
			     i_B => jumpaddress,
			     o_D => jumporbranch);

	--Switch between previous addresses or register address for jump
	JRSWITCHER : mux_Nbit_2in
		generic map(N => N)
		port map(c_S => jrselect,
			     i_A => jumporbranch,
			     i_B => aluresult,
			     o_D => PCUpdate);
end structure;

