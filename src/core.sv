import definitions::*;

module core(
	input logic i_clk,
	input logic i_reset,
	input t_data i_instruction,
	output t_address o_instruction_address,
	output t_address o_data_address,
	output t_data o_out_data,
	output logic o_memory_write_enable
);
	typedef enum {STAGE_FETCH_INSTRUCTION, STAGE_FETCH_REGISTERS, STAGE_EXECUTE} t_stage;
	t_stage r_current_stage;
	t_data r_pc;
	t_data w_next_pc;
	t_data r_current_instruction;

	t_data r_operand1, r_operand2, w_actual_operand2;
	t_data w_out_register1, w_out_register2;

	t_branch_condition w_branch_condition;

	logic w_destination_register_write_enable;
	t_register_index w_source_register_idx1, w_source_register_idx2, w_destination_register_idx;

	logic w_use_immediate;
	t_data w_immediate;

	t_alu_operation w_alu_operation;
	t_data w_alu_result;
	logic w_alu_zero;

	logic w_register_write_enable;

	always_ff@(posedge i_clk, posedge i_reset) begin
		if (i_reset) begin
			r_pc = 32'b0;
			r_current_instruction = 32'b0;
			r_current_stage = STAGE_FETCH_INSTRUCTION;
		end else begin
			case (r_current_stage)
				STAGE_FETCH_INSTRUCTION: begin
					r_current_instruction <= i_instruction;
					r_current_stage <= STAGE_FETCH_REGISTERS;
				end
				STAGE_FETCH_REGISTERS: begin
					r_operand1 <= w_out_register1;
					r_operand2 <= w_out_register2;
					r_current_stage <= STAGE_EXECUTE;
				end
				STAGE_EXECUTE: begin
					r_pc <= w_next_pc;
					r_current_stage <= STAGE_FETCH_INSTRUCTION;
				end
				// default: begin
				// 	r_current_stage <= STAGE_FETCH_REGISTERS;
				// end
			endcase
		end
	end

	always_comb begin
		if (w_branch_condition == BRANCH_JUMP) begin
			w_next_pc = r_pc + w_immediate;
		end else if (w_branch_condition == BRANCH_NE && ~w_alu_zero) begin
			w_next_pc = r_pc + w_immediate;
		end else begin
			w_next_pc = r_pc + 4;
		end
	end

	assign w_register_write_enable = r_current_stage == STAGE_EXECUTE
		&& w_destination_register_write_enable;

	register_file register_file_inst(
		.i_clk(i_clk),
		.i_out_register_idx1(w_source_register_idx1),
		.i_out_register_idx2(w_source_register_idx2),
		.i_in_register_idx(w_destination_register_idx),
		.i_in_data(w_alu_result),
		.i_write_enable(w_register_write_enable),
		.o_out_register1(w_out_register1),
		.o_out_register2(w_out_register2)
	);

	decoder decoder_inst(
		.i_instruction(r_current_instruction),
		.o_source_register1(w_source_register_idx1),
		.o_source_register2(w_source_register_idx2),
		.o_destination_register(w_destination_register_idx),
		.o_destination_register_write_enable(w_destination_register_write_enable),
		.o_alu_operation(w_alu_operation),
		.o_immediate(w_immediate),
		.o_use_immediate(w_use_immediate),
		.o_branch_condition(w_branch_condition),
		.o_memory_write_enable()
	);

	assign w_actual_operand2 = w_use_immediate ? w_immediate : r_operand2;

	alu alu_inst(
		.i_operation(w_alu_operation),
		.i_operand1(r_operand1),
		.i_operand2(w_actual_operand2),
		.o_result(w_alu_result),
		.o_zero(w_alu_zero)
	);

	assign o_instruction_address = r_pc;
	// TODO: assign o_data_address, o_out_data and o_memory_write_enable
	assign o_data_address = 32'b0;
	assign o_out_data = 32'b0;
	assign o_memory_write_enable = 1'b0;

	`ifdef COCOTB_SIM
	`ifdef TEST_core
	initial begin
		$dumpfile("../../tb_output/core.vcd");
		$dumpvars(0, core);
		// for (int i = 0; i < 32; ++i) begin
		// 	$dumpvars(0, core.register_file_inst.r_registers[i]);
		// end
		#1;
	end
	`endif
	`endif
endmodule
