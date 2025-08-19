import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
logger = cocotb.logging.getLogger("cocotb")

NCO_BITS = 4
NCO_FREQ_BITS = 4


@cocotb.test()
async def nco_test(dut):
    # Inicializar el reloj
    cocotb.start_soon(Clock(dut.clk_in, 10, units='ns').start())
    # Resetear el DUT
    dut.rst_in.value = 1
    dut.fcw_in.value = 0
    await RisingEdge(dut.clk_in)
    dut.rst_in.value = 0
    await RisingEdge(dut.clk_in)
    assert dut.nco_out.value == 0, f"Expected 0, got {dut.nco_out.value}"
    assert dut.rst_in.value == 0, f"Expected 0, got {dut.rst_in.value}"

    max_count = (2**NCO_BITS)

    max_word = (2**NCO_FREQ_BITS)
    for value in range(1, max_word):
        dut.fcw_in.value = value
        dut.rst_in.value = 1
        await RisingEdge(dut.clk_in)
        dut.rst_in.value = 0
        
        # Verificar el conteo de salida
        for i in range(0, max_count, value):
            final_value = (i + value) % max_count
            await RisingEdge(dut.clk_in)
            assert dut.nco_out.value.integer == i, f"Expected {i}, got {dut.nco_out.value.integer}, value={value}"

        await RisingEdge(dut.clk_in)
        assert dut.nco_out.value.integer == final_value, f"Expected {final_value}, got {dut.nco_out.value.integer}, value={value}"
