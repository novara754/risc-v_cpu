library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.risc_v.all;

-- Memory block allowing simulatenous access to
-- instructions and data.
-- Instructions and data can be read from the selected
-- addresses asynchonously.
-- Data writes happen on the rising edge of the given clock signal.
-- When writing data to a selected address that same data will be reported on the
-- `o_out_data` output starting at the rising edge of the clock.
--
-- At the moment this memory module only supports addresses 0 to 1023.
entity memory is
	port (
		-- Clock signal
		i_clk : in std_logic;
		-- Address selector for instruction fetching
		i_inst_address : in t_address;
		-- Address selector for data reads and writes
		i_data_address : in t_address;
		-- Data to be written to the selected data adress
		-- if `i_write_enable` is asserted
		i_in_data : in t_data;
		-- Write enable signal determining whether to write to in-register
		i_write_enable : in std_logic;
		-- Instruction at the selected instruction address
		o_instruction : out t_data;
		-- Data at the selected data address
		o_out_data : out t_data
	);
end memory;

architecture rtl of memory is
	type t_memory is array(0 to 1023) of t_data;
	signal r_memory : t_memory := (others => (others => '0'));
begin
	process (i_clk)
	begin
		if rising_edge(i_clk) and i_write_enable = '1' then
			r_memory(to_integer(i_data_address(9 downto 0))) <= i_in_data;
		end if;
	end process;

	o_instruction <= r_memory(to_integer(i_inst_address(9 downto 0)));
	o_out_data <= r_memory(to_integer(i_data_address(9 downto 0)));
end rtl;
