library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

use work.risc_v.all;

entity core_tb is
end core_tb;

architecture rtl of core_tb is
	signal r_clk : std_logic := '0';
	signal r_instruction : t_data := (others => '0');
	signal w_inst_address : t_data;
begin
	uut : entity work.core(rtl)
		port map (
			i_clk => r_clk,
			i_instruction => r_instruction,
			o_inst_address => w_inst_address
		);

	CLK_GEN : process
		constant c_CLOCK_HALF_PERIOD : time := 10 ns;
	begin
		wait for c_CLOCK_HALF_PERIOD;
		r_clk <= not r_clk;
	end process;

	TEST : process
		constant c_SMALL_TIME : time := 5 ns;
	begin
		r_instruction <= X"3E80_0093";
		wait until r_clk = '1';

		r_instruction <= X"7D00_8113";
		wait until r_clk = '1';

		r_instruction <= X"C181_0193";
		wait until r_clk = '1';

		r_instruction <= X"8301_8213";
		wait until r_clk = '1';

		r_instruction <= X"3E82_0293";
		wait until r_clk = '1';

		report "ALL TESTS FINISHED" severity note;

		--finish;
	end process;
end rtl;
