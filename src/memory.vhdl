library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.risc_v.all;

-- Memory block allowing simulatenous access to
-- instructions and data.
--
-- Instructions and data can be read from the selected
-- addresses asynchonously.
--
-- Data writes happen on the rising edge of the given clock signal.
-- When writing data to a selected address that same data will be reported on the
-- `o_out_data` output starting at the rising edge of the clock.
-- The module also allows specifying a write mask to allow writing data of
-- different sizes, be it a byte, half-word or word. This is used for the SW, SH
-- and SB instructions.
--
-- The memory module allows initialization from a file. This file must follow the
-- following format:
--  * Text file
--  * One line per 32-bit value
--  * Each value encoded as a hexadecimal number
--
-- At the moment this memory module only supports addresses 1024 words of data.
entity memory is
	generic (
		g_source_file_name : string := ""
	);
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
		-- Write mask determining at which bytes of a word to write the data.
		-- Bit 0 specifies the least significant byte
		i_write_mask : in std_logic_vector(3 downto 0);
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

	impure function read_file (source_file_name : in string) return t_memory is
		use std.textio.all;
		file source_file : text is in source_file_name;
		variable source_line : line;
		variable word : std_logic_vector(31 downto 0);
		variable program : t_memory;
	begin
		for i in t_memory'range loop
			if not endfile(source_file) then
				readline(source_file, source_line);
				hread(source_line, word);
				program(i) := unsigned(word);
			else
				program(i) := (others => '0');
			end if;
		end loop;
		return program;
	end function;

	impure function init_memory return t_memory is
	begin
		if g_source_file_name = "" then
			return (others => (others => '0'));
		else
			return read_file(g_source_file_name);
		end if;
	end function;

	signal r_memory : t_memory := init_memory;

	signal w_inst_offset : unsigned(29 downto 0);
	signal w_data_offset : unsigned(29 downto 0);
begin
	process (i_clk)
	begin
		if rising_edge(i_clk) and i_write_enable = '1' then
			if (i_write_mask(0) = '1') then
				r_memory(to_integer(w_data_offset))( 7 downto  0) <= i_in_data( 7 downto  0);
			end if;
			if (i_write_mask(1) = '1' ) then
				r_memory(to_integer(w_data_offset))(15 downto  8) <= i_in_data(15 downto  8);
			end if;
			if (i_write_mask(2) = '1' ) then
				r_memory(to_integer(w_data_offset))(23 downto 16) <= i_in_data(23 downto 16);
			end if;
			if (i_write_mask(3) = '1' ) then
				r_memory(to_integer(w_data_offset))(31 downto 24) <= i_in_data(31 downto 24);
			end if;
		end if;
	end process;

	o_instruction <= r_memory(to_integer(w_inst_offset));
	o_out_data <= r_memory(to_integer(w_data_offset));

	w_data_offset <= i_data_address(31 downto 2);
	w_inst_offset <= i_inst_address(31 downto 2);
end rtl;
