library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.risc_v.all;

entity processor is
	port (
		i_clk : in std_logic
	);
end processor ;

architecture rtl of processor is
	signal w_instruction : t_data;
	signal w_inst_address : t_address;
begin
	core_inst : entity work.core(rtl)
		port map (
			i_clk => i_clk,
			i_instruction => w_instruction,
			o_inst_address => w_inst_address
		);

	memory_inst : entity work.memory(rtl)
		port map (
			i_clk => i_clk,
			i_inst_address => w_inst_address,
			i_data_address => (others => '0'),
			i_in_data => (others => '0'),
			i_write_enable => '0',
			o_instruction => w_instruction,
			o_out_data => open
		);
end architecture;
