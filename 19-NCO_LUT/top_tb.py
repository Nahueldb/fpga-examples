import cocotb
import matplotlib.pyplot as plt
import numpy as np
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
logger = cocotb.logging.getLogger("cocotb")

NCO_BITS = 10
NCO_FREQ_BITS = 4
DATA_OUT_BITS = 12
FCW_VALUE = 1  # Valor fijo para fcw_in

@cocotb.test()
async def top_test(dut):
    # Inicializar el reloj
    cocotb.start_soon(Clock(dut.clk_in, 10, units='ns').start())
    # Resetear el DUT
    dut.rst_in.value = 1
    dut.fcw_in.value = FCW_VALUE
    await RisingEdge(dut.clk_in)
    dut.rst_in.value = 0
    await RisingEdge(dut.clk_in)
    assert dut.nco_out.value == 0, f"Expected 0, got {dut.nco_out.value}"
    assert dut.rst_in.value == 0, f"Expected 0, got {dut.rst_in.value}"

    max_count = (2**NCO_BITS)

    # max_word = (2**NCO_FREQ_BITS)
    # for value in range(1, max_word):
    # dut.fcw_in.value = value
    dut.rst_in.value = 1
    await RisingEdge(dut.clk_in)
    dut.rst_in.value = 0

    with open("sine_table.hex", "r") as f:
        lut_values = [int(line.strip(), 16) for line in f.readlines()]
    samples = []
    # Verificar el conteo de salida
    for i in range(0, max_count, FCW_VALUE):
        # final_value = (i + FCW_VALUE) % max_count
        await RisingEdge(dut.clk_in)
        assert dut.data_out.value.integer == lut_values[i], f"Expected {lut_values[i]}, got {dut.data_out.value.integer}, value={FCW_VALUE}"
        samples.append(dut.data_out.value.integer)

    samples = np.array(samples)
    spectrum = np.fft.fft(samples)
    freq = np.fft.fftfreq(len(samples))
    plt.plot(freq[:len(freq)//2], 20*np.log10(np.abs(spectrum[:len(spectrum)//2])))
    plt.title("NCO Spectrum")
    plt.xlabel("Normalized Frequency (fs=1)")
    plt.ylabel("Magnitude (dB)")
    plt.grid()
    plt.savefig("nco_output_spectrum.png")

    plt.close()

    plt.plot(samples)
    plt.title("NCO Output Waveform")
    plt.xlabel("Sample Number")
    plt.ylabel("Amplitude")
    plt.grid()
    plt.savefig("nco_output_waveform.png")
    plt.close()
