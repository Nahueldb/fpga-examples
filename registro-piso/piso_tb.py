import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

PRESET_VALUE = 5  # Valor a cargar en el registro
PRESET_VALUES = [0, 1, 0, 1]  # Valores esperados en cada ciclo de reloj

@cocotb.test()
async def piso_tb_functionality(dut):
    # Inicializar el reloj
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())

    dut.out_enable_in.value = 1
    await RisingEdge(dut.clk)
    dut.load_enable_in.value = 1
    await RisingEdge(dut.clk)
    dut.clk_enable.value = 1

    # Cargar los valores en el registro SISO
    dut.d_in.value = PRESET_VALUE
    await RisingEdge(dut.clk)
    dut.load_enable_in.value = 0
    await RisingEdge(dut.clk)

    # Verificar el contenido del registro SISO
    for expected_value in PRESET_VALUES:
        assert dut.q_out == expected_value, f"Expected {expected_value}, got {dut.q_out}"
        await RisingEdge(dut.clk)


@cocotb.test()
async def piso_tb_reset(dut):
    # Inicializar el reloj
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    # Verificar que el registro SISO se haya reiniciado
    assert dut.q_out == 0, f"Expected 0 after reset, got {dut.q_out}"


@cocotb.test()
async def piso_tb_output_enable(dut):
    # Inicializar el reloj
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())

    dut.out_enable_in.value = 0
    await RisingEdge(dut.clk)

    # Verificar que la salida esté deshabilitada
    assert str(dut.q_out.value) == "z" or "z" in str(dut.q_out.value), f"Error: Expected high impedance, got {dut.q_out.value}"
