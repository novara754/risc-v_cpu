library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.risc_v.all;

-- Register file for general purpose registers of a
-- RISC-V processor.
-- The register file supports reading two registers at a time,
-- both of which can be the same. It also supports writing to a
-- single register if the `i_write_enable` signal is asserted.
-- Write operations occur on the rising edge of the given clock signal.
-- Read operations are asynchronous.
entity register_file is
	port (
		-- Clock input
		i_clk : in std_logic;
		-- Index of the first register to read
		i_out_register_idx1 : in t_register_index;
		-- Index of the second register to read
		i_out_register_idx2 : in t_register_index;
		-- Index of the register to write
		i_in_register_idx : in t_register_index;
		-- Data to write to the in-register
		i_in_data : in t_data;
		-- Write enable signal determining whether to write to in-register
		i_write_enable : in std_logic;
		-- Value of the first output register
		o_out_register1 : out t_data;
		-- Value of the second output register
		o_out_register2 : out t_data
	);
end register_file;

architecture rtl of register_file is
	type t_register_file is array (0 to 31) of t_data;
	signal r_registers : t_register_file := (others => (others => '0'));
begin
	process (i_clk)
	begin
		if rising_edge(i_clk) and i_write_enable = '1' then
			r_registers(to_integer(i_in_register_idx)) <= i_in_data;
			r_registers(0) <= (others => '0');
		end if;
	end process;

	o_out_register1 <= r_registers(to_integer(i_out_register_idx1));
	o_out_register2 <= r_registers(to_integer(i_out_register_idx2));
end rtl;
