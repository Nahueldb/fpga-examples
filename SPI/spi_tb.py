import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
logger = cocotb.logging.getLogger("cocotb")

T = 83.33            # periodo del clk
N_BITS = 12
DATA_BITS = 0b100000101010


@cocotb.test()
async def spi_test(dut):
    # clk = 12 MHz  (periodo 83.33 ns)
    cocotb.start_soon(Clock(dut.clk, T, units="ns").start())

    dut.ssel_in.value = 1
    await RisingEdge(dut.clk)

    dut.ssel_in.value = 0
    await RisingEdge(dut.clk)

    with open("sine_table.hex", "r") as f:
        lut_values = [int(line.strip(), 16) for line in f.readlines()]

    for i in range(N_BITS):
        await RisingEdge(dut.clk)
        assert dut.miso.value == (DATA_BITS >> (N_BITS - 1 - i)) & 1

    await RisingEdge(dut.clk)
    assert dut.d_reg_master.value == DATA_BITS