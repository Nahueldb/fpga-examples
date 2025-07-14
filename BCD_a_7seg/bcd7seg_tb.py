import cocotb
from cocotb.triggers import Timer

COMMON_ANODE = True  # Set to True for common anode, False for common cathode


@cocotb.test()
async def bcd7seg_tb(dut):
    """Testbench for the BCD to 7-segment decoder."""

    # Test all valid BCD inputs
    for bcd in range(16):
        dut.bcd_in.value = bcd
        await Timer(10, units='ns')
        expected_output = {
            0: 0b1111110,
            1: 0b0110000,
            2: 0b1101101,
            3: 0b1111001,
            4: 0b0110011,
            5: 0b1011011,
            6: 0b1011111,
            7: 0b1110000,
            8: 0b1111111,
            9: 0b1111011,
            10: 0b1110111, # A
            11: 0b0011111, # B
            12: 0b1001110, # C
            13: 0b0111101, # D
            14: 0b1001111, # E
            15: 0b1000111, # F
        }.get(bcd, 0b0000000)
        if COMMON_ANODE:
            expected_output = ~expected_output & 0b1111111
        assert dut.sseg_out.value.integer == expected_output, f"Output for BCD {bcd} should be {expected_output:07b}, got {dut.sseg_out.value.integer:07b}"
