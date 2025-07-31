import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

PRESET_VALUES = [5, 20, 170]  # Valores a cargar en el registro


@cocotb.test()
async def test_pipo_functionality(dut):
    # Initialize clock
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.start_soon(clock.start())

    dut.out_enable_in.value = 1

    for value in PRESET_VALUES:
        dut.clk_enable.value = 1
        await RisingEdge(dut.clk)
        # Test writing to the register
        dut.d_in.value = value
        await RisingEdge(dut.clk)
        dut.clk_enable.value = 0  # Disable clock to hold the value
        dut.d_in.value = 0  # Clear input to avoid accidental writes
        await RisingEdge(dut.clk)
        assert dut.q_out.value.integer == value, f"Write failed: expected {value}, got {dut.q_out.value.integer}"


@cocotb.test()
async def test_reset(dut):
    # Initialize clock
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.start_soon(clock.start())

    # Reset the DUT
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    # Check initial state
    assert dut.q_out.value.integer == 0, "Reset failed: q_out != 0"