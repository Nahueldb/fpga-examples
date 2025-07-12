import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

COUNT_MAX = 10  # Adjusted for testing purposes

@cocotb.test()
async def blink_tb(dut):
    """Testbench for the BLINK."""
    # simulate the clock
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.start_soon(clock.start())

    initial_led = dut.led.value.integer
    assert initial_led == 0, f"Initial LED value should be 0, got {initial_led}"

    # Wait for the first clock edge
    for _ in range(COUNT_MAX + 1): # Wait for enough clock cycles to toggle the LED
        await RisingEdge(dut.clk)
    assert dut.led.value.integer == 1, "LED should toggle after first clock edge"