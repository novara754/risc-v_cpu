library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

use work.risc_v.all;

entity memory_tb is
end memory_tb;

architecture rtl of memory_tb is
	signal r_clk : std_logic := '0';
	signal r_inst_address : t_address := (others => '0');
	signal r_data_address : t_address := X"0000_0004";
	signal r_in_data : t_data := (others => '0');
	signal r_write_mask : std_logic_vector(3 downto 0) := (others => '0');
	signal r_write_enable : std_logic := '0';
	signal w_instruction : t_data;
	signal w_out_data : t_data;
begin
	uut : entity work.memory(rtl)
		port map (
			i_clk => r_clk,
			i_inst_address => r_inst_address,
			i_data_address => r_data_address,
			i_in_data => r_in_data,
			i_write_mask => r_write_mask,
			i_write_enable => r_write_enable,
			o_instruction => w_instruction,
			o_out_data => w_out_data
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
		r_data_address <= X"0000_0004";
		r_in_data <= X"0000_4321";
		r_write_mask <= "1111";
		r_write_enable <= '0';
		wait until (r_clk = '1');

		r_data_address <= (others => '0');
		wait for c_SHORT_TIME;
		assert (w_out_data = X"0000_0000")
			report "test 1 failed" severity failure;
		----------------------------------------------

		-- TEST WRITE WORD AND READ BACK --
		report "WRITE WORD AND READ BACK" severity note;
		r_data_address <= (others => '0');
		r_in_data <= X"3E80_0093";
		r_write_mask <= "1111";
		r_write_enable <= '1';
		wait until (r_clk = '1');
		r_write_enable <= '0';

		r_data_address <= (others => '0');
		wait for c_SHORT_TIME;
		assert (w_out_data = X"3E80_0093")
			report "test 2 failed" severity failure;
		-------------------------------------

		-- TEST WRITE HALF-WORD AND READ BACK WORD --
		report "WRITE HALF-WORD AND READ BACK WORD" severity note;
		r_data_address <= (others => '0');
		r_in_data <= X"0000_6AF0";
		r_write_mask <= "0011";
		r_write_enable <= '1';
		wait until (r_clk = '1');
		r_write_enable <= '0';

		r_data_address <= (others => '0');
		wait for c_SHORT_TIME;
		assert (w_out_data = X"3E80_6AF0")
			report "test 3 failed" severity failure;
		---------------------------------------------

		-- TEST SECOND WRITE AND READ BACK --
		report "SECOND WRITE AND READ BACK" severity note;
		r_data_address <= X"0000_0004";
		r_in_data <= X"8301_8213";
		r_write_mask <= "1111";
		r_write_enable <= '1';
		wait until (r_clk = '1');
		r_write_enable <= '0';

		r_inst_address <= (others => '0');
		wait for c_SHORT_TIME;
		assert (w_out_data = X"8301_8213" and w_instruction = X"3E80_6AF0")
			report "test 4 failed" severity failure;
		-------------------------------------

		-- TEST WRITE BYTE AND READ BACK WORD --
		report "WRITE BYTE AND READ BACK WORD" severity note;
		r_data_address <= (others => '0');
		r_in_data <= X"009A_0000";
		r_write_mask <= "0100";
		r_write_enable <= '1';
		wait until (r_clk = '1');
		r_write_enable <= '0';

		r_data_address <= (others => '0');
		wait for c_SHORT_TIME;
		assert (w_out_data = X"3E9A_6AF0")
			report "test 5 failed" severity failure;
		----------------------------------------

		report "ALL TESTS FINISHED" severity note;

		finish;
	end process;
end rtl;
