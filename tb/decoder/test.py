from sre_constants import BRANCH
import cocotb
from cocotb.binary import BinaryValue, BinaryRepresentation
from cocotb.triggers import Timer

ALU_OP_INVALID = 0
ALU_OP_ADD = 1
ALU_OP_SUB = 2

BRANCH_NONE = 0
BRANCH_JUMP = 1
BRANCH_NE = 2


@cocotb.test()
async def decode_addi(dut):
    # addi x1, x0, 1000
    dut.i_instruction.value = 0x3E80_0093
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == BRANCH_NONE
    assert dut.o_alu_operation.value == ALU_OP_ADD
    assert dut.o_source_register1.value == 0
    assert dut.o_use_immediate.value == 1
    assert dut.o_immediate.value == 0x0000_03E8
    assert dut.o_destination_register.value == 1
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_addi_negative(dut):
    # addi x12, x11, -45
    dut.i_instruction.value = 0xFD35_8613
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == BRANCH_NONE
    assert dut.o_alu_operation.value == ALU_OP_ADD
    assert dut.o_source_register1.value == 11
    assert dut.o_use_immediate.value == 1
    assert dut.o_immediate.value.signed_integer == -45
    assert dut.o_destination_register.value == 12
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_add(dut):
    # add x4, x3, x2
    dut.i_instruction.value = 0x0021_8233
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == BRANCH_NONE
    assert dut.o_alu_operation.value == ALU_OP_ADD
    assert dut.o_source_register1.value == 3
    assert dut.o_source_register2.value == 2
    assert dut.o_use_immediate.value == 0
    assert dut.o_destination_register.value == 4
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_bne1(dut):
    # bne x10, x0, <-16>
    dut.i_instruction.value = 0xFE05_18E3
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == BRANCH_NE
    assert dut.o_alu_operation.value == ALU_OP_SUB
    assert dut.o_source_register1.value == 10
    assert dut.o_source_register2.value == 0
    assert dut.o_use_immediate.value == 0
    assert dut.o_immediate.value.signed_integer == -16
    assert dut.o_destination_register_write_enable.value == 0


@cocotb.test()
async def decode_bne2(dut):
    # bne x3, x5, <+8>
    dut.i_instruction.value = 0x0051_9463
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == BRANCH_NE
    assert dut.o_alu_operation.value == ALU_OP_SUB
    assert dut.o_source_register1.value == 3
    assert dut.o_source_register2.value == 5
    assert dut.o_use_immediate.value == 0
    assert dut.o_immediate.value.signed_integer == 8
    assert dut.o_destination_register_write_enable.value == 0


@cocotb.test()
async def decode_sw(dut):
    # sw x1, 1234(x2)
    dut.i_instruction.value = 0x4C11_2923
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == BRANCH_NONE
    assert dut.o_alu_operation.value == ALU_OP_ADD
    assert dut.o_source_register1.value == 2
    assert dut.o_source_register2.value == 1
    assert dut.o_use_immediate.value == 1
    assert dut.o_immediate.value == 0x0000_04D2
    assert dut.o_destination_register_write_enable.value == 0


@cocotb.test()
async def decode_jal(dut):
    # j <-8>
    dut.i_instruction.value = 0xFF9F_F06F
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == BRANCH_JUMP
    assert dut.o_alu_operation.value == ALU_OP_INVALID
    assert dut.o_use_immediate.value == 0
    assert dut.o_immediate.value.signed_integer == -8
    assert dut.o_destination_register.value == 0
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_jal(dut):
    # jal ra <+32>
    dut.i_instruction.value = 0x0200_00EF
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == BRANCH_JUMP
    assert dut.o_alu_operation.value == ALU_OP_INVALID
    assert dut.o_use_immediate.value == 0
    assert dut.o_immediate.value.signed_integer == 32
    assert dut.o_destination_register.value == 1
    assert dut.o_destination_register_write_enable.value == 1
