library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.mips32.all;
use work.cpurecordsv4.all;

entity controlv4 is
	port(op_code       : in  m32_6bits;
		 o_control_out : out m32_control_out);
end controlv4;

architecture rom of controlv4 is
	subtype code_t is m32_vector(14 downto 0);
	type rom_t is array (0 to 63) of code_t;

	-- The ROM content
	-- Format: reg_dst, alu_src, mem_to_reg, reg_write, mem_read, 
	-- mem_write, branch(eq, ne),alu_op(2) alu_op(1), alu_op(0), jal, jump, upper, signedload
	signal rom : rom_t := (
		--	      "RAMRMMBBOOOJJUU
		0      => "100100000000001",    -- R-type instruction (add, sub, and, or, slt)
		2      => "---00000---0101",    -- j
		3      => "---00000---1101",    -- jal
		4      => "-0-000100100001",    -- beq
		5      => "-0-000010100001",    -- bne
		8      => "010100000010001",    -- addi
		9      => "010100000010000",    -- addiu
		10     => "010100000110001",    -- slti
		11     => "010100000110000",    -- sltiu
		12     => "010100001000001",    -- andi
		13     => "010100001010001",    -- ori
		14     => "010100001100001",    -- xori
		15     => "010100000010011",    -- lui
		35     => "011110000010001",    -- lw
		43     => "-1-001000010001",    -- sw

		others => "000000000000000");

begin
		(o_control_out.reg_dst,
			o_control_out.alu_src,
			o_control_out.mem_to_reg,
			o_control_out.reg_write,
			o_control_out.mem_read,
			o_control_out.mem_write,
			o_control_out.branch(0),
			o_control_out.branch(1),
			o_control_out.alu_op(2),
			o_control_out.alu_op(1),
			o_control_out.alu_op(0),
			o_control_out.jal,
			o_control_out.jump,
			o_control_out.upper,
			o_control_out.signedload) <= rom(to_integer(unsigned(op_code)));
end rom;

