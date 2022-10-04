from re import X
import cocotb
from cocotb.triggers import FallingEdge, RisingEdge, Timer
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

    cocotb.start_soon(Clock(dut.i_clk, period=10,
                      units="ns").start(start_high=False))

    dut.i_reset.value = 1
    await Timer(10, units="ns")

    while True:
        await FallingEdge(dut.i_clk)
        dut.i_reset.value = 0

        # for i in range(20):
        # dut._log.info(f"STAGE={dut.r_current_stage.value}")

        pc = dut.o_instruction_address.value

        adjusted_pc = pc >> 2
        if adjusted_pc >= len(program):
            break

        instruction = program[adjusted_pc]
        dut.i_instruction.value = instruction

        # dut._log.info(f"PC={pc.value:08X}\tIR={instruction:08X}")
        # regs = list(
        #     enumerate(reversed(dut.register_file_inst.r_registers.value)))[10:14]
        # dut._log.info('\t'.join(f"x{i}={reg.value}" for (i, reg) in regs))

        await RisingEdge(dut.i_clk)

    regs = list(
        reversed(dut.register_file_inst.r_registers.value))
    assert regs[10] == 21
