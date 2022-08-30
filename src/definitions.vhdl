library ieee;
use ieee.numeric_std.all;

package risc_v is
	subtype t_register_index is unsigned(4 downto 0);
	subtype t_byte is unsigned(7 downto 0);
	subtype t_data is unsigned(31 downto 0);
	subtype t_address is unsigned(31 downto 0);
	type t_alu_operation is (alu_op_invalid, alu_op_add, alu_op_sub);
	type t_branch_condition is (branch_none, branch_ne);
end package risc_v;
