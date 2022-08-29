library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.risc_v.all;

entity core is
	port (
		i_clk : in std_logic;
		i_instruction : in t_data;
		o_inst_address : out t_address
	);
end core;

architecture rtl of core is
	signal r_pc : t_address := (others => '0');

	signal w_alu_operation : std_logic_vector(2 downto 0);
	signal w_source_register1 : t_register_index;
	signal w_source_register2 : t_register_index;
	signal w_immediate : t_data;
	signal w_use_immediate : std_logic;
	signal w_destination_register : t_register_index;
	signal w_destination_register_write_enable : std_logic;

	signal w_operand1 : t_data;
	signal w_operand2 : t_data;
	signal w_actual_operand2 : t_data;
	signal w_alu_result : t_data;
begin
	decoder_inst : entity work.decoder(rtl)
		port map (
			i_instruction => i_instruction,
			o_alu_operation => w_alu_operation,
			o_source_register1 => w_source_register1,
			o_source_register2 => w_source_register2,
			o_immediate => w_immediate,
			o_use_immediate => w_use_immediate,
			o_destination_register => w_destination_register,
			o_destination_register_write_enable => w_destination_register_write_enable
		);

	alu_inst : entity work.alu(rtl)
		port map (
			i_operation => w_alu_operation,
			i_operand1 => w_operand1,
			i_operand2 => w_actual_operand2,
			o_result => w_alu_result
		);

	register_file_inst : entity work.register_file(rtl)
		port map (
			i_clk => i_clk,
			i_out_register_idx1 => w_source_register1,
			i_out_register_idx2 => w_source_register2,
			i_in_register_idx => w_destination_register,
			i_in_data => w_alu_result,
			i_write_enable => w_destination_register_write_enable,
			o_out_register1 => w_operand1,
			o_out_register2 => w_operand2
		);

	process (i_clk)
	begin
		if rising_edge(i_clk) then
			r_pc <= r_pc + 4;
		end if;
	end process;

	w_actual_operand2 <= w_immediate when w_use_immediate = '1' else w_operand2;

	o_inst_address <= r_pc;
end rtl;
