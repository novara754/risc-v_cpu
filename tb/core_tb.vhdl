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

	type t_program is array (0 to 8) of t_data;
	signal r_program : t_program := (
		-- A small program to calculate fibonacci numbers
		-- Expected result:
		--   x10 = 8
		--   x11 = 8
		--   x12 = 13
		--   x13 = 5
		X"0050_0513", -- addi x10, x0, 5		-- N = 5
		X"0010_0593", -- addi x11, x0, 1		-- A = 1
		X"0010_0613", -- addi x12, x0, 1		-- B = 1
		-- loop:
		X"FFF5_0513", -- addi x10, x10, -1		-- N = N - 1
		X"0005_8693", -- addi x13, x11, 0		-- C = A
		X"0006_0593", -- addi x11, x12, 0		-- A = B
		X"00D6_0633", -- add  x12, x12, x13		-- B = B + C
		X"FE05_18E3", -- bne  x10, x0, loop		-- if N != 0 goto loop
		X"0005_8513"  -- addi x10, x11, 0		-- return B
	);
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
		alias a_program_index : unsigned(29 downto 0) is w_inst_address(31 downto 2);
	begin
		if a_program_index < 9 then
			r_instruction <= r_program(to_integer(a_program_index));
		else
			r_instruction <= X"0000_0000";
		end if;

		wait for c_SMALL_TIME;

		report "ALL TESTS FINISHED" severity note;

		--finish;
	end process;
end rtl;
