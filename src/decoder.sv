`default_nettype none

import definitions::*;

module decoder(
	// Instruction to decode
	input t_data i_instruction,
	// First source register index
	output t_register_index o_source_register1,
	// Second source register index
	output t_register_index o_source_register2,
	// Destination register index
	output t_register_index o_destination_register,
	// Destination register write enable signal
	output logic o_destination_register_write_enable,
	// Operation selector to be forwarded to the ALU
	output t_alu_operation o_alu_operation,
	// Immediate value
	output t_data o_immediate,
	// Whether to use the immediate value or read from second source register
	output logic o_use_immediate,
	// If the instruction is a branch instruction this specifies the branch condition,
	// otherwise it is simply `branch_none`
	output t_branch_condition o_branch_condition,
	// Write enable for memory access
	output logic o_memory_write_enable
);
	logic [6:0] w_opcode;
	assign w_opcode = i_instruction[6:0];

	logic [2:0] w_funct3;
	assign w_funct3 = i_instruction[14:12];

	assign o_source_register1 = i_instruction[19:15];
	assign o_source_register2 = i_instruction[24:20];
	assign o_destination_register = i_instruction[11:7];

	t_data w_i_immediate, w_b_immediate, w_s_immediate, w_j_immediate;
	assign w_i_immediate = { {21{i_instruction[31]}}, i_instruction[30:20] };
	assign w_b_immediate = {
		{20{i_instruction[31]}},
		i_instruction[7],
		i_instruction[30:25],
		i_instruction[11:8],
		1'b0
	};
	assign w_s_immediate = { {21{i_instruction[31]}}, i_instruction[30:25], i_instruction[11:7] };
	assign w_j_immediate = {
		{12{i_instruction[31]}},
		i_instruction[19:12],
		i_instruction[20],
		i_instruction[30:25],
		i_instruction[24:21],
		1'b0
	};

	always_comb begin
		// Default values
		o_alu_operation = ALU_OP_INVALID;
		o_destination_register_write_enable = 1'b0;
		o_immediate = 32'b0;
		o_use_immediate = 1'b0;
		o_branch_condition = BRANCH_NONE;
		o_memory_write_enable = 1'b0;

		// See Ch. 19 of the RISC-V specification for details
		// on instruction encoding.
		case (w_opcode)
			// OP-IMM
			7'b0010011: begin
				o_immediate = w_i_immediate;
				case (w_funct3)
					3'b000: o_alu_operation = ALU_OP_ADD;
					3'b100: o_alu_operation = ALU_OP_XOR;
					3'b110: o_alu_operation = ALU_OP_OR;
					3'b111: o_alu_operation = ALU_OP_AND;
					3'b001: o_alu_operation = ALU_OP_SHIFT_LEFT;
					3'b101: begin
						// Remove errneous bit due to SRAI encoding
						o_immediate[10] = 1'b0;
						o_alu_operation = i_instruction[30]
							? ALU_OP_SHIFT_RIGHT_ARITH
							: ALU_OP_SHIFT_RIGHT_LOGIC;
					end
					default: o_alu_operation = ALU_OP_INVALID;
				endcase
				o_destination_register_write_enable = 1'b1;
				o_use_immediate = 1'b1;
			end
			// OP
			7'b0110011: begin
				o_alu_operation = (w_funct3 == 3'b000) ? ALU_OP_ADD : ALU_OP_INVALID;
				o_destination_register_write_enable = 1'b1;
				o_use_immediate = 1'b0;
			end
			// BRANCH
			7'b1100011: begin
				o_alu_operation = ALU_OP_SUB;
				o_destination_register_write_enable = 1'b0;
				o_immediate = w_b_immediate;
				o_use_immediate = 1'b0;
				o_branch_condition = (w_funct3 == 3'b001) ? BRANCH_NE : BRANCH_NONE;
			end
			// STORE
			7'b0100011: begin
				o_alu_operation = ALU_OP_ADD;
				o_destination_register_write_enable = 1'b0;
				o_immediate = w_s_immediate;
				o_use_immediate = 1'b1;
				o_memory_write_enable = 1'b1;
			end
			// JAL
			7'b1101111: begin
				o_branch_condition = BRANCH_JUMP;
				o_destination_register_write_enable = 1'b1;
				o_immediate = w_j_immediate;
			end
			default: begin
				o_alu_operation = ALU_OP_INVALID;
				o_destination_register_write_enable = 1'b0;
				o_immediate = 32'b0;
				o_use_immediate = 1'b0;
				o_branch_condition = BRANCH_NONE;
				o_memory_write_enable = 1'b0;
			end
		endcase
	end

	`ifdef COCOTB_SIM
	`ifdef TEST_decoder
	initial begin
		$dumpfile("../../tb_output/decoder.vcd");
		$dumpvars(0, decoder);
		#1;
	end
	`endif
	`endif
endmodule
