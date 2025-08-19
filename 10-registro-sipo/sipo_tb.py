import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
logger = cocotb.logging.getLogger("cocotb")

PRESET_VALUES = [1, 0, 0, 1]  # Valores a cargar en el registro

@cocotb.test()
async def sipo_tb(dut):
    # Inicializar el reloj
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())

    # Resetear el DUT
    dut.out_enable_in.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    assert dut.q_out.value.integer == 0, "Error: Expected initial output to be 0"

    # Cargar los valores en el registro SIPO
    for value in PRESET_VALUES:
        dut.d_in.value = value
        logger.info(f"Loading value: {value}")
        await RisingEdge(dut.clk)

    # Verificar el contenido del registro SIPO
    await RisingEdge(dut.clk)
    assert dut.q_out.value.integer == 9, f"Expected 9, got {dut.q_out.value}"

    # Verificar el estado del registro cuando no se permite la salida
    dut.out_enable_in.value = 0
    await RisingEdge(dut.clk)
    assert str(dut.q_out.value) == "z" or "z" in str(dut.q_out.value), f"Error: Expected high impedance, got {dut.q_out.value}"
