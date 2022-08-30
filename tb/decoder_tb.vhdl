library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

use work.risc_v.all;

entity decoder_tb is
end decoder_tb;

architecture rtl of decoder_tb is
	signal r_instruction : t_data := (others => '0');
	signal w_alu_operation : t_alu_operation;
	signal w_source_register1 : t_register_index;
	signal w_source_register2 : t_register_index;
	signal w_immediate : t_data;
	signal w_use_immediate : std_logic;
	signal w_destination_register : t_register_index;
	signal w_destination_register_write_enable : std_logic;
begin
	uut : entity work.decoder(rtl)
		port map (
			i_instruction => r_instruction,
			o_alu_operation => w_alu_operation,
			o_source_register1 => w_source_register1,
			o_source_register2 => w_source_register2,
			o_immediate => w_immediate,
			o_use_immediate => w_use_immediate,
			o_destination_register => w_destination_register,
			o_destination_register_write_enable => w_destination_register_write_enable
		);

	TEST : process
		constant c_SMALL_TIME : time := 5 ns;
	begin
		-- TEST DECODE ADDI INSTRUCTION --
		report "TEST DECODE ADDI INSTRUCTION" severity note;
		r_instruction <= X"3E80_0093";
		wait for c_SMALL_TIME;

		assert ((w_alu_operation = alu_op_add)
			and (w_source_register1 = "00000")
			and (w_immediate = X"0000_03E8")
			and (w_use_immediate = '1')
			and (w_destination_register = "00001")
			and (w_destination_register_write_enable = '1')
		) report time'image(now) & " test 1 failed" severity failure;
		----------------------------------

		-- TEST DECODE ADD INSTRUCTION --
		report "TEST DECODE ADD INSTRUCTION" severity note;
		r_instruction <= X"0021_8233";
		wait for c_SMALL_TIME;

		assert ((w_alu_operation = alu_op_add)
			and (w_source_register1 = "00011")
			and (w_source_register2 = "00010")
			and (w_use_immediate = '0')
			and (w_destination_register = "00100")
			and (w_destination_register_write_enable = '1')
		) report time'image(now) & " test 1 failed" severity failure;
		----------------------------------

		report "ALL TESTS FINISHED" severity note;

		finish;
	end process;
end rtl;
