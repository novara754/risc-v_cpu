import definitions::*;

// Register file for general purpose registers of a
// RISC-V processor.
// The register file supports reading two registers at a time,
// both of which can be the same. It also supports writing to a
// single register if the `i_write_enable` signal is asserted.
// Write operations occur on the rising edge of the given clock signal.
// Read operations are asynchronous.
module register_file(
	// Clock input
	input logic i_clk,
	// Index of the first register to read
	input t_register_index i_out_register_idx1,
	// Index of the second register to read
	input t_register_index i_out_register_idx2,
	// Index of the register to write
	input t_register_index i_in_register_idx,
	// Data to write to the in-register
	input t_data i_in_data,
	// Write enable signal determining whether to write to in-register
	input logic i_write_enable,
	// Value of the first output register
	output t_data o_out_register1,
	// Value of the second output register
	output t_data o_out_register2
);
	t_data r_registers [31:0];
	initial begin
		for (int i = 0; i < 32; ++i) begin
			r_registers[i] = 32'b0;
		end
	end

	always_ff@(posedge i_clk) begin
		if (i_write_enable && i_in_register_idx != 5'b0) begin
			r_registers[i_in_register_idx] <= i_in_data;
		end
	end

	assign o_out_register1 = r_registers[i_out_register_idx1];
	assign o_out_register2 = r_registers[i_out_register_idx2];
endmodule
