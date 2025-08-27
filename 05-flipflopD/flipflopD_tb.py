import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def flipflopD_tb(dut):
    """Testbench for the FLIP FLOP D."""
    
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.start_soon(clock.start())

    dut.rst_in.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)  # Wait for two clock cycles to ensure reset is applied
    assert dut.q_out.value.integer == 0, "Q should be 0 after reset"

    dut.rst_in.value = 0
    dut.d_in.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.q_out.value.integer == 0, "Q should be 0"

    dut.d_in.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.q_out.value.integer == 1, "Q should be 1 after D is set to 1 on clock edge"

    dut.rst_in.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.q_out.value.integer == 0, "Q should be reset to 0 after reset signal is high"
