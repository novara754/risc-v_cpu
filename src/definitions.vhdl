library ieee;
use ieee.numeric_std.all;

package risc_v is
	subtype t_register_index is unsigned(4 downto 0);
	subtype t_data is unsigned(31 downto 0);
	subtype t_address is unsigned(31 downto 0);
end package risc_v;
