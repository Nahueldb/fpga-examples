import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

COUNT_MAX = 5*180  # Adjusted for testing purposes

@cocotb.test()
async def test_timer(dut):
    # Initialize the clock
    clock = Clock(dut.clk, 1, units='ns')
    cocotb.start_soon(clock.start())

    await RisingEdge(dut.clk)  # Wait for the first clock edge
    await RisingEdge(dut.clk)  # Wait for the second clock edge
    dut.signal_in.value = 1

    for _ in range(COUNT_MAX):
        await RisingEdge(dut.clk)
