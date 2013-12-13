library IEEE;
use IEEE.std_logic_1164.all;
use work.utils.all;
use work.mips32.all;

package cpurecords is
	-- Control unit put signals
	type m32_control_out is record
		reg_dst    : m32_1bit;
		alu_src    : m32_1bit;
		mem_to_reg : m32_1bit;
		reg_write  : m32_1bit;
		mem_read   : m32_1bit;
		mem_write  : m32_1bit;
		branch     : m32_2bits;
		alu_op     : m32_3bits;
		jump       : m32_1bit;
		jal        : m32_1bit;
		upper      : m32_1bit;
		signedload : m32_1bit;
	end record;

	type m32_alucontrol_out is record
		jr      : m32_1bit;
		shift   : m32_1bit;
		alucont : m32_vector(6 downto 0);
	end record;

	-- The IF/ID register input/output type
	type m32_IFID is record
		pc_plus_4   : m32_word;
		inst        : m32_word;
		inst_string : string(1 to 30);
	end record;

	-- The ID/EX register input/output type
	type m32_IDEX is record
		-- Control signals
		control     : m32_control_out;
		inst        : m32_word;
		inst_string : string(1 to 30);

		-- Next sequetial PC
		PC_plus_4   : m32_word;
		jumpaddress : m32_word;

		-- 32-bit register/immediate values
		rdata1       : m32_word;
		rdata2       : m32_word;
		sign_ext_imm : m32_word;

		-- Register numbers
		rs : m32_5bits;
		rt : m32_5bits;
		rd : m32_5bits;
	end record;

	-- The EX/MEM register input/output type
	type m32_EXMEM is record
		-- Control signals
		control     : m32_control_out;
		inst        : m32_word;
		inst_string : string(1 to 30);

		-- Next sequetial PC
		PC_plus_4     : m32_word;
		jumpaddress   : m32_word;
		branchaddress : m32_word;

		-- ALU Results
		aluresult : m32_word;
		aluzero   : m32_1bit;
		rdata2    : m32_word;

		-- Register numbers
		rs : m32_5bits;
		rt : m32_5bits;
		rd : m32_5bits;
	end record;

	-- The MEM/WB register input/output type
	type m32_MEMWB is record
		-- Control signals
		control     : m32_control_out;
		inst        : m32_word;
		inst_string : string(1 to 30);

		-- Next sequetial PC
		jumpaddress            : m32_word;
		branch_or_plus4address : m32_word;

		-- ALU Result and Memory Read Data
		aluresult : m32_word;
		mem_data  : m32_word;

		-- Register numbers
		rs : m32_5bits;
		rt : m32_5bits;
		rd : m32_5bits;
	end record;

end package;
