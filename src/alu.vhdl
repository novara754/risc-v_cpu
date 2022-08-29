library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.risc_v.all;

entity alu is
	port (
		-- Operation to perform on the input operands
		i_operation : in std_logic_vector(2 downto 0);
		-- First operand value
		i_operand1 : in t_data;
		-- Second operand value
		i_operand2 : in t_data;
		-- Result of the operation
		o_result : out t_data
	);
end alu;

architecture rtl of alu is

begin
	process (all)
	begin
		case i_operation is
			-- Addition
			when "000" =>
				o_result <= i_operand1 + i_operand2;
			when others =>
				o_result <= (others => '0');
		end case;
	end process;
end rtl;
