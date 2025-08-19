import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def comparador_tb(dut):
    """Testbench for the COMPARADOR."""

    dut.a_in.value = 0
    dut.b_in.value = 0
    await Timer(1, units='ns')
    assert dut.gt_out.value.integer == 0, "Initial gt value should be 0"
    assert dut.lt_out.value.integer == 0, "Initial lt value should be 0"
    assert dut.eq_out.value.integer == 1, "Initial eq value should be 1"

    dut.a_in.value = 1
    dut.b_in.value = 0

    await Timer(1, units='ns')
    assert dut.gt_out.value.integer == 1, "gt should be 1 when a > b"
    assert dut.lt_out.value.integer == 0, "lt should be 0 when a > b"
    assert dut.eq_out.value.integer == 0, "eq should be 0 when a > b"

    dut.a_in.value = 0
    dut.b_in.value = 1
    await Timer(1, units='ns')
    assert dut.gt_out.value.integer == 0, "gt should be 0 when a < b"
    assert dut.lt_out.value.integer == 1, "lt should be 1 when a < b"
    assert dut.eq_out.value.integer == 0, "eq should be 0 when a < b"

    dut.a_in.value = 1
    dut.b_in.value = 1
    await Timer(1, units='ns')
    assert dut.gt_out.value.integer == 0, "gt should be 0 when a == b"
    assert dut.lt_out.value.integer == 0, "lt should be 0 when a == b"
    assert dut.eq_out.value.integer == 1, "eq should be 1 when a == b"
