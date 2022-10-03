from re import X
import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock


def hex_list(ls):
    return '[{}]'.format(', '.join(f"0x{((x >> 16) & 0xFFFF):04X}_{(x & 0xFFFF):04X}" for x in ls))


def read_program(name):
    program = []
    with open(f"progs/build/{name}.bin", "rb") as f:
        while True:
            bs = f.read(4)
            if len(bs) != 4:
                break
            word = (bs[3] << 24) | (bs[2] << 16) | (bs[1] << 8) | bs[0]
            program.append(word)
    return program


@cocotb.test()
async def fibonacci(dut):
    program = read_program("fib")

    cocotb.start_soon(Clock(dut.i_clk, period=10, units="ns").start())

    await RisingEdge(dut.i_clk)

    for i in range(20):
        # while True:
        pc = dut.o_inst_address.value.integer

        dut._log.info(
            f"PC=0x{pc:08X}")

        inst_idx = pc >> 2
        if inst_idx >= len(program):
            break

        inst = program[inst_idx]
        dut.i_instruction.value = inst

    #     dut._log.info(
    #         f"PC=0x{pc:08X}, INSTRUCTION={inst:08X}")

        await RisingEdge(dut.i_clk)

    #     # dut._log.info(
    #     #     "\t".join(f"X{i}={x.integer}" for (i, x) in list(enumerate(
    #     #         dut.register_file_inst.r_registers.value))[10:14]))
    #     # dut._log.info("\n")

    x10 = dut.register_file_inst.r_registers.value[10].value
    assert x10 == 21

    # adjusted_pc = 0
    # while adjusted_pc < len(program):
    #     pc = dut.o_inst_address.value.integer
    #     adjusted_pc = pc >> 2
    #     instruction = program[adjusted_pc] if adjusted_pc < len(program) else 0
    #     dut.i_instruction.value = instruction

    #     await RisingEdge(dut.i_clk)

    #     dut._log.info(
    #         "\t".join(f"X{i}={x.integer}" for (i, x) in list(enumerate(
    #             dut.register_file_inst.r_registers.value))[10:14]))
    #     dut._log.info(
    #         f"PC=0x{dut.o_inst_address.value.integer:08X}, INSTRUCTION={instruction:08X}")
    #     dut._log.info("\n")

    # dut._log.info(f"{ dut.register_file_inst.r_registers.value }")

    # x10 = dut.register_file_inst.r_registers.value[10].value
    # assert x10 == 21, f"x10=0x{x10:08X}"
