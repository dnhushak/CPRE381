library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use work.mips32.all;

package cpurecords is
	-- Control unit put signals
	type m32_control_out is record
		reg_dst    : m32_1bit; -- EX
		alu_src    : m32_1bit; -- EX
		mem_to_reg : m32_1bit; -- WB
		reg_write  : m32_1bit; -- WB
		mem_read   : m32_1bit; -- MEM
		mem_write  : m32_1bit; -- MEM
		branch     : m32_2bits; -- MEM
		alu_op     : m32_3bits; -- EX
		jump       : m32_1bit; -- 
		jal        : m32_1bit;
		upper      : m32_1bit;
		signedload : m32_1bit;
	end record;

	type m32_alucontrol_out is record
		jr      : m32_1bit;
		shift   : m32_1bit;
		alucont : m32_vector(6 downto 0);
	end record;

	-- EX stage control signals
	type m32_EX_ctrl is record
		alu_src : m32_1bit;
		alu_op  : m32_2bits;
		reg_dst : m32_1bit; -- Note: It is consumed at EX
	end record;

	-- MEM stage control signals
	type m32_MEM_ctrl is record
		mem_read  : m32_1bit;
		mem_write : m32_1bit;
		branch    : m32_1bit;
	end record;

	-- WB stage control signals
	type m32_WB_ctrl is record
		reg_write  : m32_1bit;
		mem_to_reg : m32_1bit;
	end record;

	-- The IF/ID register input/output type
	type m32_IFID is record
		pc_plus_4 : m32_word;
		inst      : m32_word;
	end record;

	-- The IF/ID register input/output type
	type m32_IDEX is record
		-- Control signals
		EX_ctrl  : m32_EX_ctrl;
		MEM_ctrl : m32_MEM_ctrl;
		WB_ctrl  : m32_WB_ctrl;

		-- Next sequetial PC
		PC_plus_4 : m32_word;

		-- 32-bit register/immediate values
		rdata1       : m32_word;
		rdata2       : m32_word;
		sign_ext_imm : m32_word;

		-- Register numbers
		rs : m32_5bits;
		rt : m32_5bits;
		rd : m32_5bits;
	end record;

-- MORE
end package;
