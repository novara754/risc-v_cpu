from enum import Enum, auto
import random

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


@cocotb.test()
async def controlled_addition(dut):
    print(AluOp.ADD.value)
    dut.i_operation.value = AluOp.ADD.value
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

        dut.i_operation.value = AluOp.ADD.value
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
    dut.i_operation.value = AluOp.SUB.value
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

        dut.i_operation.value = AluOp.SUB.value
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
async def controlled_xor(dut):
    dut.i_operation.value = AluOp.XOR.value
    dut.i_operand1.value = 0x0000_1234
    dut.i_operand2.value = 0x00A0_500F

    await Timer(1, units="ns")

    assert dut.o_result.value == 0x00A0_423b
    assert dut.o_zero.value == 0


@cocotb.test()
async def random_xor(dut):
    for i in range(10):
        operand1 = random.randint(0, 1 << 32 - 1)
        operand2 = random.randint(0, 1 << 32 - 1)

        dut.i_operation.value = AluOp.XOR.value
        dut.i_operand1.value = operand1
        dut.i_operand2.value = operand2

        await Timer(1, units="ns")

        expected_result = (operand1 ^ operand2)
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
async def controlled_or(dut):
    dut.i_operation.value = AluOp.OR.value
    dut.i_operand1.value = 0x0000_1234
    dut.i_operand2.value = 0x00A0_500F

    await Timer(1, units="ns")

    assert dut.o_result.value == 0x00A0_523F
    assert dut.o_zero.value == 0


@cocotb.test()
async def random_or(dut):
    for i in range(10):
        operand1 = random.randint(0, 1 << 32 - 1)
        operand2 = random.randint(0, 1 << 32 - 1)

        dut.i_operation.value = AluOp.OR.value
        dut.i_operand1.value = operand1
        dut.i_operand2.value = operand2

        await Timer(1, units="ns")

        expected_result = (operand1 | operand2)
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
async def controlled_and(dut):
    dut.i_operation.value = AluOp.AND.value
    dut.i_operand1.value = 0x0000_1234
    dut.i_operand2.value = 0x00A0_500F

    await Timer(1, units="ns")

    assert dut.o_result.value == 0x0000_1004
    assert dut.o_zero.value == 0


@cocotb.test()
async def random_and(dut):
    for i in range(10):
        operand1 = random.randint(0, 1 << 32 - 1)
        operand2 = random.randint(0, 1 << 32 - 1)

        dut.i_operation.value = AluOp.AND.value
        dut.i_operand1.value = operand1
        dut.i_operand2.value = operand2

        await Timer(1, units="ns")

        expected_result = (operand1 & operand2)
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
async def controlled_left_shift(dut):
    dut.i_operation.value = AluOp.SHIFT_LEFT.value
    dut.i_operand1.value = 0x00A0_500F
    dut.i_operand2.value = 5

    await Timer(1, units="ns")

    assert dut.o_result.value == 0x140A01E0
    assert dut.o_zero.value == 0


@cocotb.test()
async def random_left_shift(dut):
    for i in range(10):
        operand1 = random.randint(0, 1 << 32 - 1)
        operand2 = random.randint(0, 1 << 5 - 1)

        dut.i_operation.value = AluOp.SHIFT_LEFT.value
        dut.i_operand1.value = operand1
        dut.i_operand2.value = operand2

        await Timer(1, units="ns")

        expected_result = (operand1 << operand2) & 0xFFFF_FFFF
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
async def controlled_right_shift_logic(dut):
    dut.i_operation.value = AluOp.SHIFT_RIGHT_LOGIC.value
    dut.i_operand1.value = 0xF2A0_500F
    dut.i_operand2.value = 3

    await Timer(1, units="ns")

    assert dut.o_result.value == 0x1E54_0A01
    assert dut.o_zero.value == 0


@cocotb.test()
async def random_right_shift_logic(dut):
    for i in range(10):
        operand1 = random.randint(0, 1 << 32 - 1)
        operand2 = random.randint(0, 1 << 5 - 1)

        dut.i_operation.value = AluOp.SHIFT_RIGHT_LOGIC.value
        dut.i_operand1.value = operand1
        dut.i_operand2.value = operand2

        await Timer(1, units="ns")

        expected_result = (operand1 >> operand2) & 0xFFFF_FFFF
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
async def controlled_right_shift_arith(dut):
    dut.i_operation.value = AluOp.SHIFT_RIGHT_ARITH.value
    dut.i_operand1.value = 0xF2A0_500F
    dut.i_operand2.value = 3

    await Timer(1, units="ns")

    assert dut.o_result.value == 0xFE54_0A01
    assert dut.o_zero.value == 0


@cocotb.test()
async def random_right_shift_arith(dut):
    for i in range(10):
        operand1 = random.randint(0, 1 << 32 - 1)
        operand2 = random.randint(0, 1 << 5 - 1)

        dut.i_operation.value = AluOp.SHIFT_RIGHT_ARITH.value
        dut.i_operand1.value = operand1
        dut.i_operand2.value = operand2

        await Timer(1, units="ns")

        expected_result = operand1 >> operand2
        # Emulate SRA on unsigned values in Python
        if (operand1 >> 31) & 1 != 0:
            expected_result |= 0xFFFF_FFFF_0000_0000 >> operand2
            expected_result &= 0xFFFF_FFFF
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
    dut.i_operation.value = AluOp.SUB.value
    dut.i_operand1.value = 0x0000_1234
    dut.i_operand2.value = 0x0000_1234

    await Timer(1, units="ns")

    assert dut.o_result.value == 0x0000_0000
    assert dut.o_zero.value == 1
