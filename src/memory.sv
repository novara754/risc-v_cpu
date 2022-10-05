`default_nettype none

import definitions::*;

// Memory block allowing simulatenous access to
// instructions and data.
//
// Instructions and data can be read from the selected
// addresses asynchonously.
//
// Data writes happen on the rising edge of the given clock signal.
// When writing data to a selected address that same data will be reported on the
// `o_out_data` output starting at the rising edge of the clock.
// The module also allows specifying a write mask to allow writing data of
// different sizes, be it a byte, half-word or word. This is used for the SW, SH
// and SB instructions.
//
// At the moment this memory module only supports addresses 1024 words of data.
module memory(
	// Clock signal
	input logic i_clk,
	// Address selector for instruction fetching
	input t_address i_inst_address,
	// Address selector for data reads and writes
	input t_address i_data_address,
	// Data to be written to the selected data adress
	// if `i_write_enable` is asserted
	input t_data i_in_data,
	// Write mask determining at which bytes of a word to write the data.
	// Bit 0 specifies the least significant byte
	input logic [3:0] i_write_mask,
	// Write enable signal determining whether to write to in-register
	input logic i_write_enable,
	// Instruction at the selected instruction address
	output t_data o_instruction,
	// Data at the selected data address
	output t_data o_out_data
);
	t_data r_memory [1023:0];
	initial begin
		for (int i = 0; i < 1024; ++i) begin
			r_memory[i] = 32'b0;
		end
	end

	t_address w_inst_offset, w_data_offset;
	assign w_inst_offset = { 2'b0, i_inst_address[31:2] };
	assign w_data_offset = { 2'b0, i_data_address[31:2] };

	always_ff@(posedge i_clk) begin
		if (i_write_enable) begin
			if (i_write_mask[0]) begin
				r_memory[w_data_offset][ 7: 0] <= i_in_data[ 7: 0];
			end
			if (i_write_mask[1]) begin
				r_memory[w_data_offset][15: 8] <= i_in_data[15: 8];
			end
			if (i_write_mask[2]) begin
				r_memory[w_data_offset][23:16] <= i_in_data[23:16];
			end
			if (i_write_mask[3]) begin
				r_memory[w_data_offset][31:24] <= i_in_data[31:24];
			end
		end;
	end

	assign o_instruction = r_memory[w_inst_offset];
	assign o_out_data = r_memory[w_data_offset];

	`ifdef COCOTB_SIM
	`ifdef TEST_memory
	initial begin
		$dumpfile("../../tb_output/memory.vcd");
		$dumpvars(0, memory);
		#1;
	end
	`endif
	`endif
endmodule
