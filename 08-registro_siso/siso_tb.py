import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

PRESET_VALUES = [1, 0, 0, 1]  # Valores a cargar en el registro

@cocotb.test()
async def siso_tb(dut):
    # Inicializar el reloj
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())

    # Resetear el DUT
    dut.rst.value = 1
    dut.out_enable_in.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    # Cargar los valores en el registro SISO
    for value in PRESET_VALUES:
        dut.d_in.value = value
        await RisingEdge(dut.clk)

    # Verificar el contenido del registro SISO
    for expected_value in PRESET_VALUES:
        await RisingEdge(dut.clk)
        assert dut.q_out == expected_value, f"Expected {expected_value}, got {dut.q_out}"

    # Verificar el estado del registro cuando no se permite la salida
    dut.out_enable_in.value = 0
    await RisingEdge(dut.clk)
    assert str(dut.q_out.value) == "z" or "z" in str(dut.q_out.value), f"Error: Expected high impedance, got {dut.q_out.value}"

    # Permitir la salida y verificar nuevamente
    dut.out_enable_in.value = 1
    await RisingEdge(dut.clk)
    assert dut.q_out == PRESET_VALUES[-1], f"Expected {PRESET_VALUES[-1]}, got {dut.q_out}"
