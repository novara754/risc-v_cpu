package definitions;
	typedef logic [31:0] t_data;
	typedef logic [31:0] t_address;
	typedef logic [4:0] t_register_index;
	typedef enum {
		ALU_OP_INVALID,
		ALU_OP_ADD,
		ALU_OP_SUB,
		ALU_OP_XOR,
		ALU_OP_OR,
		ALU_OP_AND
	} t_alu_operation;
	typedef enum {BRANCH_NONE, BRANCH_JUMP, BRANCH_NE} t_branch_condition;
endpackage
