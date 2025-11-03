import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
logger = cocotb.logging.getLogger("cocotb")

T = 83.33            # periodo del clk
N_BITS = 12
DATA_BITS = 0b100000101010
SINE_VALUES = 1024

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

    for j in range(SINE_VALUES):
        logger.info(f"Starting SPI transfer {j}, expecting value {lut_values[j]:b}")
        for i in range(N_BITS):
            await RisingEdge(dut.clk)
            assert dut.miso.value == (lut_values[j] >> (N_BITS - 1 - i)) & 1, f"Expected bit {(lut_values[j] >> (N_BITS - 1 - i)) & 1}, got {dut.miso.value}, at j={j}, i={i}"
            logger.info(f"Expected bit {(lut_values[j] >> (N_BITS - 1 - i)) & 1}, got {dut.miso.value}, at j={j}, i={i}, test_wire={dut.test_wire.value}")
        await RisingEdge(dut.clk)
        assert dut.d_reg_master.value == lut_values[j], f"Expected {lut_values[j]}, got {dut.d_reg_master.value}, at j={j}"
        logger.info(f"SPI transfer {j} successful: received {dut.d_reg_master.value}, expected {lut_values[j]:b}")
        dut.ssel_in.value = 1
        await RisingEdge(dut.clk)

        dut.ssel_in.value = 0
        await RisingEdge(dut.clk)

    await RisingEdge(dut.clk)