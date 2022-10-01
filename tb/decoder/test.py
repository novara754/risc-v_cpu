import cocotb
from cocotb.triggers import Timer

ALU_OP_INVALID = 0
ALU_OP_ADD = 1
ALU_OP_SUB = 2


@cocotb.test()
async def decode_addi(dut):
    dut.i_instruction.value = 0x3E80_0093
    await Timer(1, units="ns")

    assert dut.o_alu_operation.value == ALU_OP_ADD
    assert dut.o_source_register1.value == 0
    assert dut.o_use_immediate.value == 1
    assert dut.o_immediate.value == 0x0000_03E8
    assert dut.o_destination_register.value == 1
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_add(dut):
    dut.i_instruction.value = 0x0021_8233
    await Timer(1, units="ns")

    assert dut.o_alu_operation.value == ALU_OP_ADD
    assert dut.o_source_register1.value == 3
    assert dut.o_source_register2.value == 2
    assert dut.o_use_immediate.value == 0
    assert dut.o_destination_register.value == 4
    assert dut.o_destination_register_write_enable.value == 1


@cocotb.test()
async def decode_bne(dut):
    dut.i_instruction.value = 0xFE05_18E3
    await Timer(1, units="ns")

    assert dut.o_alu_operation.value == ALU_OP_SUB
    assert dut.o_source_register1.value == 10
    assert dut.o_source_register2.value == 0
    assert dut.o_use_immediate.value == 0
    assert dut.o_immediate.value == 0xFFFF_FFF0
    assert dut.o_destination_register_write_enable.value == 0


@cocotb.test()
async def decode_sw(dut):
    dut.i_instruction.value = 0x4C11_2923
    await Timer(1, units="ns")

    assert dut.o_alu_operation.value == ALU_OP_ADD
    assert dut.o_source_register1.value == 2
    assert dut.o_source_register2.value == 1
    assert dut.o_use_immediate.value == 1
    assert dut.o_immediate.value == 0x0000_04D2
    assert dut.o_destination_register_write_enable.value == 0


@cocotb.test()
async def decode_jal(dut):
    dut.i_instruction.value = 0xFF9F_F06F
    await Timer(1, units="ns")

    assert dut.o_alu_operation.value == ALU_OP_INVALID
    assert dut.o_use_immediate.value == 0
    assert dut.o_immediate.value == 0xFFFF_FFF8
    assert dut.o_destination_register.value == 0
    assert dut.o_destination_register_write_enable.value == 1
