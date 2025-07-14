import cocotb
from cocotb.triggers import Timer

COMMON_ANODE = True  # Set to True for common anode, False for common cathode


@cocotb.test()
async def bcd7seg_tb(dut):
    """Testbench for the BCD to 7-segment decoder."""
    

    # case (bcd_in)
    #     4'b0000: sseg_out = 7'b1111110;
    #     4'b0001: sseg_out = 7'b0110000;
    #     4'b0010: sseg_out = 7'b1101101;
    #     4'b0011: sseg_out = 7'b1111001;
    #     4'b0100: sseg_out = 7'b0110011;
    #     4'b0101: sseg_out = 7'b1011011;
    #     4'b0110: sseg_out = 7'b1011111;
    #     4'b0111: sseg_out = 7'b1110000;
    #     4'b1000: sseg_out = 7'b1111111;
    #     4'b1001: sseg_out = 7'b1111011;
    #     4'b1010: sseg_out = 7'b1110111; // A
    #     4'b1011: sseg_out = 7'b0011111; // B
    #     4'b1100: sseg_out = 7'b1001110; // C
    #     4'b1101: sseg_out = 7'b0111101; // D
    #     4'b1110: sseg_out = 7'b1001111; // E
    #     4'b1111: sseg_out = 7'b1000111; // F
    #     // Casos no válidos, todos los segmentos apagados
    #     default: sseg_out = 7'b0000000;
    # endcase

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