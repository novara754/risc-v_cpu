library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.risc_v.all;

entity decoder is
	port (
		-- Instruction to decode
		i_instruction : in t_data;
		-- Operation selector to be forwarded to the ALU
		o_alu_operation : out t_alu_operation;
		-- First source register index
		o_source_register1 : out t_register_index;
		-- Second source register index
		o_source_register2 : out t_register_index;
		-- Immediate value
		o_immediate : out t_data;
		-- Whether to use the immediate value or read from second source register
		o_use_immediate : out std_logic;
		-- Destination register index
		o_destination_register : out t_register_index;
		-- Destination register write enable signal
		o_destination_register_write_enable : out std_logic
	);
end decoder;

architecture rtl of decoder is
	signal w_opcode : std_logic_vector(6 downto 0);
	signal w_funct3 : std_logic_vector(2 downto 0);

	-- Immediate value for I-type instructions
	signal w_immediate_i : t_data;
begin
	w_opcode <= std_logic_vector(i_instruction(6 downto 0));
	w_funct3 <= std_logic_vector(i_instruction(14 downto 12));

	o_destination_register <= i_instruction(11 downto 7);
	o_source_register1 <= i_instruction(19 downto 15);
	o_source_register2 <= i_instruction(24 downto 20);

	w_immediate_i <= unsigned(resize(signed(i_instruction(31 downto 20)), w_immediate_i'length));

	-- process (i_clk)
	process (all)
	begin
		o_alu_operation <= alu_op_invalid;
		o_immediate <= (others => '0');
		o_use_immediate <= '0';
		o_destination_register_write_enable <= '0';

		-- See Ch. 19 of the RISC-V specification for details
		-- on instruction encodings
		case w_opcode is
			-- OP-IMM
			when "0010011" =>
				o_alu_operation <= alu_op_add when w_funct3 = "000" else alu_op_invalid;
				o_destination_register_write_enable <= '1';
				o_immediate <= w_immediate_i;
				o_use_immediate <= '1';
			-- Unknown
			when others =>
				-- empty
		end case;
	end process;
end rtl;
