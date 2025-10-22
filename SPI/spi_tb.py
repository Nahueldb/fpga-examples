import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
logger = cocotb.logging.getLogger("cocotb")

T = 83.33            # periodo del clk
N_BITS = 12
DATA_BITS = 100000101010


@cocotb.test()
async def spi_test(dut):
    # clk = 12 MHz  (periodo 83.33 ns)
    cocotb.start_soon(Clock(dut.clk, T, units="ns").start())

    dut.ssel_in.value = 1
    await RisingEdge(dut.clk)

    dut.ssel_in.value = 0
    await RisingEdge(dut.clk)

    for i in range(N_BITS):
        await RisingEdge(dut.clk)
        logger.info(f"Sending bit {i} of {N_BITS-1}")
        logger.info(f"miso: {dut.miso.value}")

    # logger.info(f"Received data: {dut.d_reg_master.value.integer:0{N_BITS}b}")