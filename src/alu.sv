import definitions::*;

module alu (
	// Operation to perform on the input operands
	input t_alu_operation i_operation,
	// First operand value
	input t_data i_operand1,
	// Second operand value
	input t_data i_operand2,
	// Result of the operation
	output t_data o_result,
	// Whether or not the result is equal to zero
	output logic o_zero
);
	always_comb begin
		case (i_operation)
			ALU_OP_ADD: o_result = i_operand1 + i_operand2;
			ALU_OP_SUB: o_result = i_operand1 - i_operand2;
			ALU_OP_XOR: o_result = i_operand1 ^ i_operand2;
			ALU_OP_OR: o_result = i_operand1 | i_operand2;
			ALU_OP_AND: o_result = i_operand1 & i_operand2;
			ALU_OP_SHIFT_LEFT: o_result = i_operand1 << i_operand2;
			ALU_OP_SHIFT_RIGHT_LOGIC: o_result = i_operand1 >> i_operand2;
			ALU_OP_SHIFT_RIGHT_ARITH: o_result = $signed(i_operand1) >>> i_operand2;
			default: o_result = 0;
		endcase
	end

	assign o_zero = o_result == 0;
endmodule
