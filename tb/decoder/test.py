from enum import Enum

import cocotb
from cocotb.triggers import Timer

AluOp = Enum("AluOp", [
    "INVALID",
    "ADD",
    "SUB",
    "XOR",
    "OR",
    "AND",
    "SHIFT_LEFT",
    "SHIFT_RIGHT_LOGIC",
    "SHIFT_RIGHT_ARITH",
], start=0)

Branch = Enum("Branch", [
    "NONE",
    "JUMP",
    "NE",
], start=0)


@cocotb.test()
async def decode_addi(dut):
    # addi x1, x0, 1000
    dut.i_instruction.value = 0x3E80_0093
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == Branch.NONE.value
    assert dut.o_alu_operation.value == AluOp.ADD.value
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

    assert dut.o_branch_condition.value == Branch.NONE.value
    assert dut.o_alu_operation.value == AluOp.ADD.value
    assert dut.o_source_register1.value == 11
    assert dut.o_use_immediate.value == 1
    assert dut.o_immediate.value.signed_integer == -45
    assert dut.o_destination_register.value == 12
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_xori(dut):
    # xori x14, x14, 15
    dut.i_instruction.value = 0x00F7_4713
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == Branch.NONE.value
    assert dut.o_alu_operation.value == AluOp.XOR.value
    assert dut.o_source_register1.value == 14
    assert dut.o_use_immediate.value == 1
    assert dut.o_immediate.value == 15
    assert dut.o_destination_register.value == 14
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_ori(dut):
    # ori x2, x3, 32
    dut.i_instruction.value = 0x0201_E113
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == Branch.NONE.value
    assert dut.o_alu_operation.value == AluOp.OR.value
    assert dut.o_source_register1.value == 3
    assert dut.o_use_immediate.value == 1
    assert dut.o_immediate.value == 32
    assert dut.o_destination_register.value == 2
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_andi(dut):
    # andi x10, x11, 255
    dut.i_instruction.value = 0x0FF5_F513
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == Branch.NONE.value
    assert dut.o_alu_operation.value == AluOp.AND.value
    assert dut.o_source_register1.value == 11
    assert dut.o_use_immediate.value == 1
    assert dut.o_immediate.value == 255
    assert dut.o_destination_register.value == 10
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_slli(dut):
    # slli x1, x2, 3
    dut.i_instruction.value = 0x0031_1093
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == Branch.NONE.value
    assert dut.o_alu_operation.value == AluOp.SHIFT_LEFT.value
    assert dut.o_source_register1.value == 2
    assert dut.o_use_immediate.value == 1
    assert dut.o_immediate.value == 3
    assert dut.o_destination_register.value == 1
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_srli(dut):
    # srli x10, x10, 8
    dut.i_instruction.value = 0x0085_5513
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == Branch.NONE.value
    assert dut.o_alu_operation.value == AluOp.SHIFT_RIGHT_LOGIC.value
    assert dut.o_source_register1.value == 10
    assert dut.o_use_immediate.value == 1
    assert dut.o_immediate.value == 8
    assert dut.o_destination_register.value == 10
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_srai(dut):
    # srai x5, x4, 6
    dut.i_instruction.value = 0x4062_5293
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == Branch.NONE.value
    assert dut.o_alu_operation.value == AluOp.SHIFT_RIGHT_ARITH.value
    assert dut.o_source_register1.value == 4
    assert dut.o_use_immediate.value == 1
    assert dut.o_immediate.value == 6
    assert dut.o_destination_register.value == 5
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_add(dut):
    # add x4, x3, x2
    dut.i_instruction.value = 0x0021_8233
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == Branch.NONE.value
    assert dut.o_alu_operation.value == AluOp.ADD.value
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

    assert dut.o_branch_condition.value == Branch.NE.value
    assert dut.o_alu_operation.value == AluOp.SUB.value
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

    assert dut.o_branch_condition.value == Branch.NE.value
    assert dut.o_alu_operation.value == AluOp.SUB.value
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

    assert dut.o_branch_condition.value == Branch.NONE.value
    assert dut.o_alu_operation.value == AluOp.ADD.value
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

    assert dut.o_branch_condition.value == Branch.JUMP.value
    assert dut.o_alu_operation.value == AluOp.INVALID.value
    assert dut.o_use_immediate.value == 0
    assert dut.o_immediate.value.signed_integer == -8
    assert dut.o_destination_register.value == 0
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_jal(dut):
    # jal ra <+32>
    dut.i_instruction.value = 0x0200_00EF
    await Timer(1, units="ns")

    assert dut.o_branch_condition.value == Branch.JUMP.value
    assert dut.o_alu_operation.value == AluOp.INVALID.value
    assert dut.o_use_immediate.value == 0
    assert dut.o_immediate.value.signed_integer == 32
    assert dut.o_destination_register.value == 1
    assert dut.o_destination_register_write_enable.value == 1
