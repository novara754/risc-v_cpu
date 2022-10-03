library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.risc_v.all;

entity alu is
	port (
		-- Operation to perform on the input operands
		i_operation : in t_alu_operation;
		-- First operand value
		i_operand1 : in t_data;
		-- Second operand value
		i_operand2 : in t_data;
		-- Result of the operation
		o_result : out t_data;
		-- Whether or not the result is equal to zero
		o_zero : out std_logic
	);
end alu;

architecture rtl of alu is
	signal r_result : t_data := X"0000_0000";
begin
	process (all)
	begin
		case i_operation is
			when alu_op_add =>
				r_result <= i_operand1 + i_operand2;
			when alu_op_sub =>
				r_result <= i_operand1 - i_operand2;
			when others =>
				r_result <= X"0000_0000";
		end case;
	end process;

	o_result <= r_result;
	o_zero <= '1' when r_result = X"0000_0000" else '0';
end rtl;
