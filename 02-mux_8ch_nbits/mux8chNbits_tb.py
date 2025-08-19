import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def mux8chNbits_tb(dut):
    """Testbench for the MUX 8 Channels N Bits."""

    dut.data_in_0.value = 0b000
    dut.data_in_1.value = 0b001
    dut.data_in_2.value = 0b010
    dut.data_in_3.value = 0b011
    dut.data_in_4.value = 0b100
    dut.data_in_5.value = 0b101
    dut.data_in_6.value = 0b110
    dut.data_in_7.value = 0b111

    await Timer(1, units='ns')

    for i in range(8):
        dut.sel_in.value = i
        await Timer(10, units='ns')  # Wait for some time to simulate clock
        # Check if the output matches the expected value
        expected_output = i
        assert dut.data_out.value == expected_output, f"Output mismatch: expected {expected_output}, got {dut.data_out.value}"
