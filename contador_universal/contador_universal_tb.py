import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, ReadOnly


PRESET_VALUE = 5  # Valor a cargar en el contador
COMMON_ANODE = True  # Indica si el display de 7 segmentos es de ánodo común

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


# @cocotb.test()
# async def test_reset(dut):
#     await setup(dut)
#     dut.counter_enable_in.value = 1
#     await RisingEdge(dut.clk)

#     # Reset
#     dut.rst.value = 1
#     await RisingEdge(dut.clk)
#     assert dut.q_out.value.integer == 0, "Reset failed: q_out != 0"
#     dut.rst.value = 0


# @cocotb.test()
# async def test_decrement(dut):
#     await setup(dut, count_up_in=0)
#     await RisingEdge(dut.clk)

#     for expected in range(15, -1, -1):
#         assert dut.q_out.value.integer == expected, f"Decrement failed at {expected}, expected {expected} but got {dut.q_out.value.integer}"
#         await RisingEdge(dut.clk)


# @cocotb.test()
# async def test_load_value(dut):
#     await setup(dut)
#     dut.load_in.value = 1
#     dut.d_in.value = PRESET_VALUE 
#     await RisingEdge(dut.clk)
#     dut.load_in.value = 0
#     await RisingEdge(dut.clk)
#     assert dut.q_out.value.integer == 5, f"Load failed: expected 5 but got {dut.q_out.value.integer}"


# @cocotb.test()
# async def test_terminal_count_up(dut):
#     await setup(dut, count_up_in=1)

#     for _ in range(15):
#         await RisingEdge(dut.clk)

#     assert dut.terminal_count_out.value == 1, "Terminal count not reached when expected"
#     assert dut.q_out.value.integer == PRESET_VALUE, "Counter did not reset to PRESET_VALUE after terminal count"
#     # Reset terminal count
#     dut.rst.value = 1
#     await RisingEdge(dut.clk)

#     assert dut.terminal_count_out.value == 0, "Terminal count not reset correctly"


# @cocotb.test()
# async def test_terminal_count_down(dut):
#     await setup(dut, count_up_in=0)

#     for _ in range(PRESET_VALUE, -1, -1):
#         await RisingEdge(dut.clk)

#     assert dut.terminal_count_out.value == 1, "Terminal count not reached when expected"
#     assert dut.q_out.value.integer == 0, "Counter did not reset to 0 after terminal count"
    
#     # Reset terminal count
#     dut.rst.value = 1
#     await RisingEdge(dut.clk)

#     assert dut.terminal_count_out.value == 0, "Terminal count not reset correctly"


@cocotb.test()
async def test_7seg_display(dut):
    await setup(dut)

    for i in range(0, 16):
        await RisingEdge(dut.clk)
        await ReadOnly()
        print(dut.sseg_out.value)
        print(i)
        assert dut.sseg_out.value == get_7seg_encoding(i), f"7-segment display failed at {i}, expected {get_7seg_encoding(i)} but got {dut.sseg_out.value}"


def get_7seg_encoding(value, common_anode=COMMON_ANODE):
    """Returns the 7-segment encoding for a given value."""
    encoding = [
        0b1111110,  # 0
        0b0110000,  # 1
        0b1101101,  # 2
        0b1111001,  # 3
        0b0110011,  # 4
        0b1011011,  # 5
        0b1011111,  # 6
        0b1110000,  # 7
        0b1111111,  # 8
        0b1111011,  # 9
        0b1110111,  # A
        0b0011111,  # B
        0b1001110,  # C
        0b0111101,  # D
        0b1001111,  # E
        0b1000111   # F
    ]
    if common_anode:
        encoding = [~x & 0b1111111 for x in encoding]
        # print(encoding)
    # Return the encoding for the value, or None if out of range
    return encoding[value] if value < len(encoding) else None