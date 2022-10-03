import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock


@cocotb.test()
async def write_disabled(dut):
    await cocotb.start(Clock(dut.i_clk, 10, units="ns").start())

    dut.i_in_register_idx.value = 14
    dut.i_in_data.value = 0x39AF_4321
    dut.i_write_enable.value = 0

    await RisingEdge(dut.i_clk)

    dut.i_out_register_idx1.value = 14
    await Timer(1, units="ns")
    assert dut.o_out_register1.value == 0x0000_0000


@cocotb.test()
async def write_enabled(dut):
    await cocotb.start(Clock(dut.i_clk, 10, units="ns").start())

    dut.i_in_register_idx.value = 14
    dut.i_in_data.value = 0x39AF_4321
    dut.i_write_enable.value = 1

    await RisingEdge(dut.i_clk)

    dut.i_out_register_idx1.value = 14
    await Timer(1, units="ns")
    assert dut.o_out_register1.value == 0x39AF_4321


@cocotb.test()
async def write_and_read(dut):
    await cocotb.start(Clock(dut.i_clk, 10, units="ns").start())

    dut.i_in_register_idx.value = 15
    dut.i_in_data.value = 12345
    dut.i_write_enable.value = 1

    await RisingEdge(dut.i_clk)

    dut.i_write_enable.value = 0
    dut.i_in_register_idx.value = 0x0000_0000

    await RisingEdge(dut.i_clk)

    dut.i_out_register_idx1.value = 15
    await Timer(1, units="ns")
    assert dut.o_out_register1.value == 12345


@cocotb.test()
async def write_and_read_r0(dut):
    await cocotb.start(Clock(dut.i_clk, 10, units="ns").start())

    dut.i_in_register_idx.value = 0
    dut.i_in_data.value = 12345
    dut.i_write_enable.value = 1

    await RisingEdge(dut.i_clk)

    dut.i_write_enable.value = 0
    dut.i_in_register_idx.value = 0x0000_0000

    await RisingEdge(dut.i_clk)

    dut.i_out_register_idx1.value = 0
    await Timer(1, units="ns")
    assert dut.o_out_register1.value == 0


@cocotb.test()
async def write_many(dut):
    await cocotb.start(Clock(dut.i_clk, 10, units="ns").start())

    dut.i_in_register_idx.value = 14
    dut.i_in_data.value = 321
    dut.i_write_enable.value = 1

    await RisingEdge(dut.i_clk)

    dut.i_write_enable.value = 0

    dut.i_in_register_idx.value = 15
    dut.i_in_data.value = 98789
    dut.i_write_enable.value = 1

    await RisingEdge(dut.i_clk)

    dut.i_write_enable.value = 0

    dut.i_out_register_idx1.value = 14
    dut.i_out_register_idx2.value = 15
    await Timer(1, units="ns")
    assert dut.o_out_register1.value == 321
    assert dut.o_out_register2.value == 98789
