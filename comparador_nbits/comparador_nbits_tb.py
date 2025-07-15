import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def comparador_nbits_tb(dut):
    """Testbench for the COMPARADOR N BITS."""


    # Test all combinations of inputs
    for a in range(4):
        for b in range(4):
            dut.a_in.value = a
            dut.b_in.value = b
            await Timer(1, units='ns')
            if a > b:
                assert dut.gt_out.value.integer == 1, f"gt should be 1 for a={a}, b={b}"
                assert dut.lt_out.value.integer == 0, f"lt should be 0 for a={a}, b={b}"
                assert dut.eq_out.value.integer == 0, f"eq should be 0 for a={a}, b={b}"
            elif a < b:
                assert dut.gt_out.value.integer == 0, f"gt should be 0 for a={a}, b={b}"
                assert dut.lt_out.value.integer == 1, f"lt should be 1 for a={a}, b={b}"
                assert dut.eq_out.value.integer == 0, f"eq should be 0 for a={a}, b={b}"
            else:
                assert dut.gt_out.value.integer == 0, f"gt should be 0 for a={a}, b={b}"
                assert dut.lt_out.value.integer == 0, f"lt should be 0 for a={a}, b={b}"
                assert dut.eq_out.value.integer == 1, f"eq should be 1 for a={a}, b={b}"
