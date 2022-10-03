import cocotb
from cocotb.triggers import RisingEdge, Timer
from cocotb.clock import Clock


@cocotb.test()
async def write_disabled(dut):
    await cocotb.start(Clock(dut.i_clk, 10, units="ns").start())

    dut.i_inst_address.value = 0x0000_0000
    dut.i_data_address.value = 0x0000_0004
    dut.i_in_data.value = 0x0000_4321
    dut.i_write_mask.value = 0b1111
    dut.i_write_enable.value = 0

    await RisingEdge(dut.i_clk)

    dut.i_data_address.value = 0x0000_0004
    await Timer(1, units="ns")
    assert dut.o_out_data.value == 0x0000_0000


@cocotb.test()
async def write_enabled(dut):
    await cocotb.start(Clock(dut.i_clk, 10, units="ns").start())

    dut.i_inst_address.value = 0x0000_0000
    dut.i_data_address.value = 0x0000_0004
    dut.i_in_data.value = 0x0000_4321
    dut.i_write_mask.value = 0b1111
    dut.i_write_enable.value = 1

    await RisingEdge(dut.i_clk)

    dut.i_data_address.value = 0x0000_0004
    await Timer(1, units="ns")
    assert dut.o_out_data.value == 0x0000_4321


@cocotb.test()
async def write_word_read_word(dut):
    await cocotb.start(Clock(dut.i_clk, 10, units="ns").start())

    dut.i_data_address.value = 0x0000_0000
    dut.i_in_data.value = 0x3E80_0093
    dut.i_write_mask.value = 0b1111
    dut.i_write_enable.value = 1

    await RisingEdge(dut.i_clk)

    dut.i_write_enable.value = 0
    dut.i_data_address.value = 0x0000_0000

    await RisingEdge(dut.i_clk)

    assert dut.o_out_data.value == 0x3E80_0093


@cocotb.test()
async def write_byte_read_word(dut):
    await cocotb.start(Clock(dut.i_clk, 10, units="ns").start())

    dut.i_data_address.value = 0x0000_0000
    dut.i_in_data.value = 0x3E80_0093
    dut.i_write_mask.value = 0b1111
    dut.i_write_enable.value = 1

    await RisingEdge(dut.i_clk)

    dut.i_data_address.value = 0x0000_0000
    dut.i_in_data.value = 0x009A_0000
    dut.i_write_mask.value = 0b0100
    dut.i_write_enable.value = 1

    await RisingEdge(dut.i_clk)

    dut.i_data_address.value = 0x0000_0000
    dut.i_write_enable.value = 0

    await RisingEdge(dut.i_clk)

    assert dut.o_out_data == 0x3E9A_0093
