import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

FREQUENCY = 10
PERIOD = (1 / FREQUENCY) * 1000
COUNT_MAX = FREQUENCY * 180  # Adjusted for testing purposes

@cocotb.test()
async def test_timer(dut):
    # Initialize the clock
    clock = Clock(dut.clk, PERIOD, units='ms')
    cocotb.start_soon(clock.start())

    dut.signal_in.value = 1
    await RisingEdge(dut.clk)  # Wait for the signal to be registered
    await RisingEdge(dut.clk)  # Wait for the next clock edge
    assert dut.led_green.value == 1, "Green LED should be on"

    for _ in range(COUNT_MAX):
        await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)  # Wait for the next clock edge after COUNT_MAX
    assert dut.led_yellow.value == 1, "Yellow LED should be on after 180 seconds"


    for _ in range(COUNT_MAX):
        await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)  # Wait for the next clock edge after COUNT_MAX
    assert dut.led_red.value == 1, "Red LED should be on after 360 seconds"

    for _ in range(COUNT_MAX):
        await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)  # Wait for the next clock edge after COUNT_MAX
    assert dut.signal_out.value == 1, "Signal out should be on after 540 seconds"