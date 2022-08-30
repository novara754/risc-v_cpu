library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

use work.risc_v.all;

entity alu_tb is
end alu_tb;

architecture rtl of alu_tb is
	signal r_operation : t_alu_operation := alu_op_invalid;
	signal r_operand1 : t_data := (others => '0');
	signal r_operand2 : t_data := (others => '0');
	signal w_result : t_data;
begin
	uut : entity work.alu(rtl)
		port map (
			i_operation => r_operation,
			i_operand1 => r_operand1,
			i_operand2 => r_operand2,
			o_result => w_result
		);

	TEST : process
		constant c_SMALL_TIME : time := 5 ns;
	begin
		-- TEST SIMPLE ADDITION --
		report "TEST SIMPLE ADDITION" severity note;
		r_operation <= alu_op_add;
		r_operand1 <= X"0000_1234";
		r_operand2 <= X"00A0_500F";
		wait for c_SMALL_TIME;
		assert (w_result = X"00A0_6243")
			report time'image(now) & " test 1 failed" severity failure;
		--------------------------

		report "ALL TESTS FINISHED" severity note;

		finish;
	end process;
end rtl;
