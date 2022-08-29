library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

use work.risc_v.all;

entity register_file_tb is
end register_file_tb;

architecture rtl of register_file_tb is
	signal r_clk : std_logic := '0';
	signal r_out_register_idx1 : t_register_index := (others => '0');
	signal r_out_register_idx2 : t_register_index := (others => '0');
	signal r_in_register_idx : t_register_index := (others => '0');
	signal r_in_data : t_data := (others => '0');
	signal r_write_enable : std_logic := '0';
	signal w_out_register1 : t_data;
	signal w_out_register2 : t_data;
begin
	uut : entity work.register_file(rtl)
		port map (
			i_clk => r_clk,
			i_out_register_idx1 => r_out_register_idx1,
			i_out_register_idx2 => r_out_register_idx2,
			i_in_register_idx => r_in_register_idx,
			i_in_data => r_in_data,
			i_write_enable => r_write_enable,
			o_out_register1 => w_out_register1,
			o_out_register2 => w_out_register2
		);

	CLK_GEN : process
		constant c_CLOCK_HALF_PERIOD : time := 10 ns;
	begin
		wait for c_CLOCK_HALF_PERIOD;
		r_clk <= not r_clk;
	end process;

	TEST : process
		constant c_SHORT_TIME : time := 5 ns;
	begin
		-- TEST WRITE ONLY IF WRITE ENABLE ASSERTED --
		report "WRITE ONLY IF WRITE ENABLE ASSERTED" severity note;
		r_in_register_idx <= to_unsigned(14, 5);
		r_in_data <= X"0000_4321";
		r_write_enable <= '0';
		wait until (r_clk = '1');

		r_out_register_idx1 <= to_unsigned(14, 5);
		wait for c_SHORT_TIME;
		assert (w_out_register1 = to_unsigned(0, 32))
			report "test 1 failed" severity failure;
		----------------------------------------------

		-- TEST SIMPLE WRITE AND READ BACK --
		report "SIMPLE WRITE AND READ BACK" severity note;
		r_in_register_idx <= to_unsigned(15, 5);
		r_in_data <= to_unsigned(12345, 32);
		r_write_enable <= '1';
		wait until (r_clk = '1');
		r_write_enable <= '0';

		r_out_register_idx1 <= to_unsigned(15, 5);
		wait for c_SHORT_TIME;
		assert (w_out_register1 = to_unsigned(12345, 32))
			report time'image(now) & " test 2 failed" severity failure;
		-------------------------------------

		-- TEST WRITE TO AND READ FROM R0 --
		report "WRITE TO AND READ FROM R0" severity note;
		r_in_register_idx <= to_unsigned(0, 5);
		r_in_data <= X"1234_5678";
		r_write_enable <= '1';
		wait until (r_clk = '1');
		r_write_enable <= '0';

		r_out_register_idx1 <= to_unsigned(0, 5);
		wait for c_SHORT_TIME;
		assert (w_out_register1 = to_unsigned(0, 32))
			report time'image(now) & " test 3 failed" severity failure;
		------------------------------------

		-- TEST MULTIPLE WRITES, OVERWRITES AND READS --
		report "MULTIPLE WRITES, OVERWRITES AND READS" severity note;
		r_in_register_idx <= to_unsigned(14, 5);
		r_in_data <= to_unsigned(321, 32);
		r_write_enable <= '1';
		wait until (r_clk = '1');
		r_write_enable <= '0';

		r_in_register_idx <= to_unsigned(15, 5);
		r_in_data <= to_unsigned(98789, 32);
		r_write_enable <= '1';
		wait until (r_clk = '1');
		r_write_enable <= '0';

		r_out_register_idx1 <= to_unsigned(14, 5);
		r_out_register_idx2 <= to_unsigned(15, 5);
		wait for c_SHORT_TIME;
		assert (w_out_register1 = to_unsigned(321, 32) and w_out_register2 = to_unsigned(98789, 32))
			report time'image(now) & " test 4 failed" severity failure;
		------------------------------------------------

		report "ALL TESTS FINISHED" severity note;

		finish;
	end process;
end rtl;
