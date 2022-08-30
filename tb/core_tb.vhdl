library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use std.env.finish;

use work.risc_v.all;

entity core_tb is
end core_tb;

architecture rtl of core_tb is
	signal r_clk : std_logic := '0';
	signal w_instruction : t_data;
	signal w_inst_address : t_data;


begin
	uut : entity work.core(rtl)
		port map (
			i_clk => r_clk,
			i_instruction => w_instruction,
			o_inst_address => w_inst_address
		);

	program_memory : entity work.memory(rtl)
		generic map (
			g_source_file_name => "core_tb_mem.bin"
		)
		port map (
			i_clk => r_clk,
			i_inst_address => w_inst_address,
			o_instruction => w_instruction,

			-- Unused
			i_data_address => X"0000_0000",
			i_in_data => X"0000_0000",
			i_write_mask => "0000",
			i_write_enable => '0',
			o_out_data => open
		);

	CLK_GEN : process
		constant c_CLOCK_HALF_PERIOD : time := 10 ns;
	begin
		wait for c_CLOCK_HALF_PERIOD;
		r_clk <= not r_clk;
	end process;

	-- TEST : process
	-- 	constant c_SMALL_TIME : time := 5 ns;
	-- 	alias a_program_index : unsigned(29 downto 0) is w_inst_address(31 downto 2);
	-- begin
	-- 	if a_program_index < 9 then
	-- 		r_instruction <= r_program(to_integer(a_program_index));
	-- 	else
	-- 		r_instruction <= X"0000_0000";
	-- 	end if;

	-- 	wait for c_SMALL_TIME;

	-- 	report "ALL TESTS FINISHED" severity note;

	-- 	--finish;
	-- end process;
end rtl;
