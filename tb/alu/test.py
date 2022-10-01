import random

import cocotb
from cocotb.triggers import Timer

ALU_OP_INVALID = 0
ALU_OP_ADD = 1
ALU_OP_SUB = 2


@cocotb.test()
async def controlled_addition(dut):
    dut.i_operation.value = ALU_OP_ADD
    dut.i_operand1.value = 0x0000_1234
    dut.i_operand2.value = 0x00A0_500F

    await Timer(1, units="ns")

    assert dut.o_result.value == 0x00A0_6243
    assert dut.o_zero.value == 0


@cocotb.test()
async def random_addition(dut):
    for i in range(10):
        operand1 = random.randint(0, 1 << 32 - 1)
        operand2 = random.randint(0, 1 << 32 - 1)

        dut.i_operation.value = ALU_OP_ADD
        dut.i_operand1.value = operand1
        dut.i_operand2.value = operand2

        await Timer(1, units="ns")

        expected_result = (operand1 + operand2) & 0xFFFF_FFFF
        expected_zero = expected_result == 0

        assert (dut.o_result.value, dut.o_zero.value) == (
            expected_result, expected_zero), (
            f"\n\toperand1={operand1:X}"
            f"\n\toperand2={operand2:X}"
            f"\n\texpected_result={expected_result:X}"
            f"\n\texpected_zero={expected_zero}"
            f"\n\to_result={dut.o_result.value.integer:X}"
            f"\n\to_zero={dut.o_zero.value}"
        )


@cocotb.test()
async def controlled_subtraction(dut):
    dut.i_operation.value = ALU_OP_SUB
    dut.i_operand1.value = 0x0000_1234
    dut.i_operand2.value = 0x00A0_500F

    await Timer(1, units="ns")

    assert dut.o_result.value == 0xFF5F_C225
    assert dut.o_zero.value == 0


@cocotb.test()
async def random_subtraction(dut):
    for i in range(10):
        operand1 = random.randint(0, 1 << 32 - 1)
        operand2 = random.randint(0, 1 << 32 - 1)

        dut.i_operation.value = ALU_OP_SUB
        dut.i_operand1.value = operand1
        dut.i_operand2.value = operand2

        await Timer(1, units="ns")

        expected_result = (operand1 - operand2) & 0xFFFF_FFFF
        expected_zero = expected_result == 0

        assert (dut.o_result.value, dut.o_zero.value) == (
            expected_result, expected_zero), (
            f"\n\toperand1={operand1:X}"
            f"\n\toperand2={operand2:X}"
            f"\n\texpected_result={expected_result:X}"
            f"\n\texpected_zero={expected_zero}"
            f"\n\to_result={dut.o_result.value.integer:X}"
            f"\n\to_zero={dut.o_zero.value}"
        )


@cocotb.test()
async def controlled_equality(dut):
    dut.i_operation.value = ALU_OP_SUB
    dut.i_operand1.value = 0x0000_1234
    dut.i_operand2.value = 0x0000_1234

    await Timer(1, units="ns")

    assert dut.o_result.value == 0x0000_0000
    assert dut.o_zero.value == 1
