-- Instruction Decoder
-- This function takes in a 32 bit MIPS instruction and outputs a 30 character string representation of that instruction.
-- This makes debugging go much quicker

-- 2013 Darren Hushak

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.mips32.all;

entity instruction_decoder is
	port(i_instr_bit : in  m32_word;
		 c_clk       : in  m32_1bit;
		 o_instr_str : out string);
end instruction_decoder;

architecture rom of instruction_decoder is
	signal s_opcode         : m32_6bits;
	signal s_rs, s_rt, s_rd : m32_5bits;
	signal s_shamt          : m32_5bits;
	signal s_funct          : m32_6bits;
	signal s_imm            : m32_vector(15 downto 0);
	signal s_addr           : m32_vector(25 downto 0);

	type funct is array (0 to 63) of string(1 to 5);
	type opcode is array (0 to 63) of string(1 to 5);
	type reg is array (0 to 31) of string(1 to 5);
	subtype String30_typ is string(1 to 30);

	signal rom_funct : funct := (
		2      => "j    ",
		3      => "jal  ",
		4      => "beq  ",
		5      => "bne  ",
		6      => "blez ",
		7      => "bgtz ",
		8      => "addi ",
		9      => "addiu",
		10     => "slti ",
		11     => "sltiu",
		12     => "andi ",
		13     => "ori  ",
		14     => "xori ",
		15     => "lui  ",
		32     => "lb   ",
		33     => "lh   ",
		34     => "lw1  ",
		35     => "lw   ",
		36     => "lbu  ",
		37     => "lhu  ",
		38     => "lwr  ",
		40     => "sb   ",
		41     => "sh   ",
		42     => "sw1  ",
		43     => "sw   ",
		46     => "swr  ",
		47     => "cache",
		48     => "ll   ",
		49     => "lwc1 ",
		50     => "lwc2 ",
		51     => "pref ",
		53     => "ldc1 ",
		54     => "ldc2 ",
		56     => "sc   ",
		57     => "swc1 ",
		58     => "swc2 ",
		61     => "sdc1 ",
		62     => "sdc2 ",
		others => "?????");

	signal rom_opcode : opcode := (
		0      => "sll  ",
		2      => "srl  ",
		3      => "sra  ",
		4      => "sllv ",
		6      => "srlv ",
		7      => "srav ",
		8      => "jr   ",
		9      => "jalr ",
		10     => "movz ",
		11     => "movn ",
		12     => "sycal",
		13     => "break",
		15     => "sync ",
		16     => "mfhi ",
		17     => "mthi ",
		18     => "mflo ",
		19     => "mtlo ",
		24     => "mult ",
		25     => "multu",
		26     => "div  ",
		27     => "divu ",
		32     => "add  ",
		33     => "addu ",
		34     => "sub  ",
		35     => "subu ",
		36     => "and  ",
		37     => "or   ",
		38     => "xor  ",
		39     => "nor  ",
		42     => "slt  ",
		43     => "sltu ",
		48     => "tge  ",
		49     => "tgeu ",
		50     => "tlt  ",
		51     => "tltu ",
		52     => "teq  ",
		54     => "tne  ",
		others => "?????");

	signal rom_reg : reg := (
		0      => "$zero",
		1      => "$at  ",
		2      => "$v0  ",
		3      => "$v1  ",
		4      => "$a0  ",
		5      => "$a1  ",
		6      => "$a2  ",
		7      => "$a3  ",
		8      => "$t0  ",
		9      => "$t1  ",
		10     => "$t2  ",
		11     => "$t3  ",
		12     => "$t4  ",
		13     => "$t5  ",
		14     => "$t6  ",
		15     => "$t7  ",
		16     => "$s0  ",
		17     => "$s1  ",
		18     => "$s2  ",
		19     => "$s3  ",
		20     => "$s4  ",
		21     => "$s5  ",
		22     => "$s6  ",
		23     => "$s7  ",
		24     => "$t8  ",
		25     => "$t9  ",
		26     => "$k0  ",
		27     => "$k1  ",
		28     => "$gp  ",
		29     => "$sp  ",
		30     => "$fp  ",
		31     => "$ra  ",
		others => "?????");

	function To30Char(StringIn : string) return String30_Typ is
		variable V : String30_Typ := (others => ' ');
	begin
		if StringIn'length > String30_Typ'length then
			return StringIn(1 to String30_Typ'length);
		else
			V(1 to StringIn'length) := StringIn;
			return V;
		end if;
	end To30Char;

begin
	process(i_instr_bit, s_funct, s_rs, s_rt, s_rd, s_shamt, s_opcode, s_imm, s_addr, c_clk)
	begin
		s_funct  <= i_instr_bit(31 downto 26);
		s_rs     <= i_instr_bit(25 downto 21);
		s_rt     <= i_instr_bit(20 downto 16);
		s_rd     <= i_instr_bit(15 downto 11);
		s_shamt  <= i_instr_bit(10 downto 6);
		s_opcode <= i_instr_bit(5 downto 0);
		s_imm    <= i_instr_bit(15 downto 0);
		s_addr   <= i_instr_bit(25 downto 0);
		if (i_instr_bit = X"00000000") then
			--Noop Instruction
			o_instr_str <= to30char("noop");
		elsif (s_funct = "000000") then
			--R type instruction
			o_instr_str <= to30char(rom_opcode(to_integer(unsigned(s_opcode))) & " " & rom_reg(to_integer(unsigned(s_rd))) & ", " & rom_reg(to_integer(unsigned(s_rs))) & ", " & rom_reg(to_integer(unsigned(s_rt))));
		elsif (s_funct = "000010" or s_funct = "000011") then
			--J type instruction
			o_instr_str <= to30char(rom_funct(to_integer(unsigned(s_funct))) & integer'image(to_integer(unsigned(s_addr))));
		else
			--I type instruction
			o_instr_str <= to30char(rom_funct(to_integer(unsigned(s_funct))) & " " & rom_reg(to_integer(unsigned(s_rt))) & ", " & rom_reg(to_integer(unsigned(s_rs))) & ", " & integer'image(to_integer(signed(s_imm))));
		end if;

	end process;
end rom;

