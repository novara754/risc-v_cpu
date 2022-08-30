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
	signal w_data_address : t_address;
	signal w_memory_write_data : t_data;
	signal w_memory_write_enable : std_logic;
begin
	uut : entity work.core(rtl)
		port map (
			i_clk => r_clk,
			i_instruction => w_instruction,
			o_inst_address => w_inst_address,
			o_memory_address => w_data_address,
			o_memory_write_data => w_memory_write_data,
			o_memory_write_enable => w_memory_write_enable
		);

	program_memory : entity work.memory(rtl)
		generic map (
			g_source_file_name => "core_tb_mem.bin"
		)
		port map (
			i_clk => r_clk,
			i_inst_address => w_inst_address,
			o_instruction => w_instruction,

			i_data_address => w_data_address,
			i_in_data => w_memory_write_data,
			i_write_mask => "1111",
			i_write_enable => w_memory_write_enable,

			-- Unused
			o_out_data => open
		);

	CLK_GEN : process
		constant c_CLOCK_HALF_PERIOD : time := 10 ns;
	begin
		wait for c_CLOCK_HALF_PERIOD;
		r_clk <= not r_clk;
	end process;
end rtl;
