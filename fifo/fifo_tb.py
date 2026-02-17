import cocotb
from cocotb.clock import Clock
from cocotb.triggers import ReadOnly, RisingEdge


T = 83.33  # Periodo del clock en nanosegundos (12 MHz)
FIFO_DEPTH = 4

@cocotb.test()
async def reset_test(dut):
    cocotb.start_soon(Clock(dut.clk, T, unit="ns").start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)
    assert dut.empty.value == 1, "Error: Expected empty to be 1 after reset"
    assert dut.full.value == 0, "Error: Expected full to be 0 after reset"
    assert dut.count.value == 0, "Error: Expected count to be 0 after reset"
    assert dut.wr_ptr.value == 0, "Error: Expected wr_ptr to be 0 after reset"
    assert dut.rd_ptr.value == 0, "Error: Expected rd_ptr to be 0 after reset"


@cocotb.test()
async def write_test(dut):
    logger = dut._log
    cocotb.start_soon(Clock(dut.clk, T, unit="ns").start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)

    dut.wr_en.value = 1
    for i in range(FIFO_DEPTH):
        dut.data_in.value = i + 1
        logger.info(f"Writing value: {i + 1}")
        await RisingEdge(dut.clk)
    dut.wr_en.value = 0
    await RisingEdge(dut.clk)

    assert dut.full.value == 1, "Error: Expected full to be 1 after writing 4 values"
    assert dut.count.value == FIFO_DEPTH, f"Error: Expected count to be {FIFO_DEPTH}, got {dut.count.value}"
    assert dut.empty.value == 0, "Error: Expected empty to be 0 after writing values"


@cocotb.test()
async def read_test(dut):
    logger = dut._log
    cocotb.start_soon(Clock(dut.clk, T, unit="ns").start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0
    await RisingEdge(dut.clk)
    assert dut.rd_ptr.value == 0, "Error: Expected rd_ptr to be 0 after reset"

    dut.wr_en.value = 1
    for i in range(FIFO_DEPTH):
        dut.data_in.value = i + 1
        await RisingEdge(dut.clk)
        logger.info(f"{i} Writing value: {i + 1}, {dut.data_in.value}")

    dut.wr_en.value = 0
    dut.rd_en.value = 1

    for i in range(FIFO_DEPTH):
        await RisingEdge(dut.clk)
        await ReadOnly()
        expected_value = i + 1
        read_value = dut.data_out.value
        logger.info(f"{i} Read value: {read_value}")
        assert read_value == expected_value, f"Error: Expected data_out to be {expected_value}, got {read_value}"

    await RisingEdge(dut.clk)

    assert dut.empty.value == 1, "Error: Expected empty to be 1 after reading all values"
