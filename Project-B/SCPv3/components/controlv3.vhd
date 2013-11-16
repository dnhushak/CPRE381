-- control.vhd: CprE 381 F13 template file
-- 
-- The main control unit of MIPS
-- 
-- Note: This is a partial example, with nine control signals (no Jump
-- singal)

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.mips32.all;

entity controlv3 is
	port(op_code    : in  m32_6bits;
		 reg_dst    : out m32_1bit;
		 alu_src    : out m32_1bit;
		 mem_to_reg : out m32_1bit;
		 reg_write  : out m32_1bit;
		 mem_read   : out m32_1bit;
		 mem_write  : out m32_1bit;
		 branch     : out m32_2bits;
		 alu_op     : out m32_3bits;
		 jump       : out m32_1bit;
		 jal        : out m32_1bit);
end controlv3;

architecture rom of controlv3 is
	subtype code_t is m32_vector(12 downto 0);
	type rom_t is array (0 to 63) of code_t;

	-- The ROM content
	-- Format: reg_dst, alu_src, mem_to_reg, reg_write, mem_read, 
	-- mem_write, branch,alu_op(2) alu_op(1), alu_op(0), jal, jump
	signal rom : rom_t := (
		--	      "RAMRMMBBOOOJJ
		0      => "1001000000000",       -- R-type instruction (add, sub, and, or, slt)
		2      => "---00000---01",       -- j
		3      => "---10000---11",       -- jal
		4      => "-0-0001001000",       -- beq
		5      => "-0-0000101000",       -- bne
		8      => "0101000000100",       -- addi
		10     => "0101000001100",       -- slti
		12     => "0101000010000",       -- andi
		13     => "0101000010100",       -- ori
		14     => "0101000011000",       -- xori
		35     => "0111100000100",       -- lw
		43     => "-1-0010000100",       -- sw

		others => "000000000000");

begin
	(reg_dst,
		alu_src,
		mem_to_reg,
		reg_write,
		mem_read,
		mem_write,
		branch(0),
		branch(1),
		alu_op(3),
		alu_op(1),
		alu_op(0),
		jal,
		jump) <= rom(to_integer(unsigned(op_code)));
end rom;

