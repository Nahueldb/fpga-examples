import cocotb
from cocotb.triggers import Timer

@cocotb.test()
async def and_tb(dut):
    """Testbench for the AND gate."""
    # Test case 1: A = 0, B = 0, Expected output = 0
    dut.a.value = 0
    dut.b.value = 0
    await Timer(1, units='ns')
    assert dut.q.value == 0

    # Test case 2: A = 0, B = 1, Expected output = 0
    dut.a.value = 0
    dut.b.value = 1
    await Timer(1, units='ns')
    assert dut.q.value == 0

    # Test case 3: A = 1, B = 0, Expected output = 0
    dut.a.value = 1
    dut.b.value = 0
    await Timer(1, units='ns')
    assert dut.q.value == 0

    # Test case 4: A = 1, B = 1, Expected output = 1
    dut.a.value = 1
    dut.b.value = 1
    await Timer(1, units='ns')
    assert dut.q.value == 1
