import definitions::*;

module core(
	input logic i_clk,
	input t_data i_instruction,
	output t_address o_instruction_address,
	output t_address o_data_address,
	output t_data o_out_data,
	output logic o_memory_write_enable,
);
	typedef enum {STAGE_FETCH_INSTRUCTION, STAGE_FETCH_REGISTERS, STAGE_EXECUTE} t_stage;
	t_stage r_current_stage;
	t_data r_pc;
	t_data r_current_instruction;

	initial begin
		r_pc = 32'b0;
		r_current_instruction = 32'b0;
		r_current_stage = STAGE_FETCH_INSTRUCTION;
	end

	always_ff@(posedge i_clk) begin
		case (r_current_stage)
			STAGE_FETCH_INSTRUCTION: begin
				r_current_instruction <= i_instruction;
				r_current_stage <= STAGE_FETCH_REGISTERS;
			end
			STAGE_FETCH_REGISTERS: begin
				r_current_stage <= STAGE_EXECUTE;
			end
			STAGE_EXECUTE: begin
				r_current_stage <= STAGE_FETCH_INSTRUCTION;
			end
		endcase
	end

	assign o_instruction_address = r_pc;
	// TODO: assign o_data_address, o_out_data and o_memory_write_enable
	assign o_data_address = 32'b0;
	assign o_out_data = 32'b0;
	assign o_memory_write_enable = 1'b0;
endmodule

// architecture rtl of core is
// 	signal r_pc : t_address := (others => '0');
// 	signal w_next_pc : t_address;

// 	signal w_alu_operation : t_alu_operation;
// 	signal w_source_register1 : t_register_index;
// 	signal w_source_register2 : t_register_index;
// 	signal w_immediate : t_data;
// 	signal w_use_immediate : std_logic;
// 	signal w_destination_register : t_register_index;
// 	signal w_destination_register_data : t_data;
// 	signal w_destination_register_write_enable : std_logic;
// 	signal w_branch_condition : t_branch_condition;

// 	signal w_operand1 : t_data;
// 	signal w_operand2 : t_data;
// 	signal w_actual_operand2 : t_data;
// 	signal w_alu_result : t_data;
// 	signal w_alu_zero : std_logic;
// begin
// 	decoder_inst : entity work.decoder(rtl)
// 		port map (
// 			i_instruction => i_instruction,
// 			o_alu_operation => w_alu_operation,
// 			o_source_register1 => w_source_register1,
// 			o_source_register2 => w_source_register2,
// 			o_immediate => w_immediate,
// 			o_use_immediate => w_use_immediate,
// 			o_destination_register => w_destination_register,
// 			o_destination_register_write_enable => w_destination_register_write_enable,
// 			o_branch_condition => w_branch_condition,
// 			o_memory_write_enable => o_memory_write_enable
// 		);

// 	alu_inst : entity work.alu(rtl)
// 		port map (
// 			i_operation => w_alu_operation,
// 			i_operand1 => w_operand1,
// 			i_operand2 => w_actual_operand2,
// 			o_result => w_alu_result,
// 			o_zero => w_alu_zero
// 		);

// 	register_file_inst : entity work.register_file(rtl)
// 		port map (
// 			i_clk => i_clk,
// 			i_out_register_idx1 => w_source_register1,
// 			i_out_register_idx2 => w_source_register2,
// 			i_in_register_idx => w_destination_register,
// 			i_in_data => w_destination_register_data,
// 			i_write_enable => w_destination_register_write_enable,
// 			o_out_register1 => w_operand1,
// 			o_out_register2 => w_operand2
// 		);

// 	process (i_clk)
// 	begin
// 		if rising_edge(i_clk) then
// 			if w_branch_condition = branch_jump then
// 				r_pc <= r_pc + w_immediate;
// 			elsif w_branch_condition = branch_ne and w_alu_zero = '0' then
// 				r_pc <= r_pc + w_immediate;
// 			else
// 				r_pc <= w_next_pc;
// 			end if;
// 		end if;
// 	end process;

// 	w_next_pc <= r_pc + 4;
// 	w_actual_operand2 <= w_immediate when w_use_immediate = '1' else w_operand2;
// 	w_destination_register_data <= w_alu_result when w_branch_condition /= branch_jump else w_next_pc;

// 	o_inst_address <= r_pc;
// 	o_memory_address <= w_alu_result;
// 	o_memory_write_data <= w_operand2;
// end rtl;
