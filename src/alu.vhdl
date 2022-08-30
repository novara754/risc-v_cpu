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

begin
	process (all)
	begin
		case i_operation is
			when alu_op_add =>
				o_result <= i_operand1 + i_operand2;
			when alu_op_sub =>
				o_result <= i_operand1 - i_operand2;
			when others =>
				o_result <= (others => '0');
		end case;
	end process;

	o_zero <= '1' when o_result = X"0000_0000" else '0';
end rtl;
