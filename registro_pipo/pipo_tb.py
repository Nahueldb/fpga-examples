import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge

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


# Uncomment the following test if you want to test negative clock edge
# @cocotb.test()
# async def test_negative_clock_edge(dut):
#     clock = Clock(dut.clk, 10, units='ns')
#     cocotb.start_soon(clock.start())

#     dut.rst.value = 0
#     dut.clk_enable.value = 1
#     dut.d_in.value = 42
#     dut.out_enable_in.value = 1
#     await FallingEdge(dut.clk)
#     dut.clk_enable.value = 0
#     await FallingEdge(dut.clk)

#     assert dut.q_out.value.integer == 42, "Negative clock edge test failed: q_out != 42"


@cocotb.test()
async def test_output_enable(dut):
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.start_soon(clock.start())

    # Disable output enable
    dut.out_enable_in.value = 0
    await RisingEdge(dut.clk)
    assert str(dut.q_out.value) == "z" or "z" in str(dut.q_out.value), f"Error: salida no es alta impedancia, q_out = {dut.q_out.value}"
