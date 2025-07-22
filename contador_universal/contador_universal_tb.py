import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

PRESET_VALUE = 5  # Valor a cargar en el contador

async def setup(dut, count_up_in=1):
    """Helper function to set up the testbench."""
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.start_soon(clock.start())

    dut.rst.value = 0
    dut.out_enable_in.value = 1
    dut.counter_enable_in.value = 1
    dut.count_up_in.value = count_up_in

    await RisingEdge(dut.clk)


@cocotb.test()
async def test_increment(dut):
    await setup(dut, count_up_in=1)

    for expected in range(1, 16):
        await RisingEdge(dut.clk)
        assert dut.q_out.value.integer == expected, f"Increment failed at {expected}, expected {expected} but got {dut.q_out.value.integer}"


@cocotb.test()
async def test_reset(dut):
    await setup(dut)
    dut.counter_enable_in.value = 1
    await RisingEdge(dut.clk)

    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    assert dut.q_out.value.integer == 0, "Reset failed: q_out != 0"
    dut.rst.value = 0


@cocotb.test()
async def test_decrement(dut):
    await setup(dut, count_up_in=0)
    await RisingEdge(dut.clk)

    for expected in range(15, -1, -1):
        assert dut.q_out.value.integer == expected, f"Decrement failed at {expected}, expected {expected} but got {dut.q_out.value.integer}"
        await RisingEdge(dut.clk)


@cocotb.test()
async def test_load_value(dut):
    await setup(dut)
    dut.load_in.value = 1
    dut.d_in.value = PRESET_VALUE 
    await RisingEdge(dut.clk)
    dut.load_in.value = 0
    await RisingEdge(dut.clk)
    assert dut.q_out.value.integer == 5, f"Load failed: expected 5 but got {dut.q_out.value.integer}"


@cocotb.test()
async def test_terminal_count_up(dut):
    await setup(dut, count_up_in=1)

    for _ in range(15):
        await RisingEdge(dut.clk)

    assert dut.terminal_count_out.value == 1, "Terminal count not reached when expected"
    assert dut.q_out.value.integer == PRESET_VALUE, "Counter did not reset to PRESET_VALUE after terminal count"
    # Reset terminal count
    dut.rst.value = 1
    await RisingEdge(dut.clk)

    assert dut.terminal_count_out.value == 0, "Terminal count not reset correctly"


@cocotb.test()
async def test_terminal_count_down(dut):
    await setup(dut, count_up_in=0)

    for _ in range(PRESET_VALUE, -1, -1):
        await RisingEdge(dut.clk)

    assert dut.terminal_count_out.value == 1, "Terminal count not reached when expected"
    assert dut.q_out.value.integer == 0, "Counter did not reset to 0 after terminal count"
    
    # Reset terminal count
    dut.rst.value = 1
    await RisingEdge(dut.clk)

    assert dut.terminal_count_out.value == 0, "Terminal count not reset correctly"