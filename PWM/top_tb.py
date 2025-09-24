import cocotb
import matplotlib.pyplot as plt
import numpy as np
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, Combine
logger = cocotb.logging.getLogger("cocotb")

NCO_BITS = 10
NCO_FREQ_BITS = 4
DATA_OUT_BITS = 12
FCW_VALUE = 1  # Valor fijo para fcw_in
RC = 2000e-6             # constante de tiempo del filtro
T = 1000            # periodo del clk_in
T_PWM = 1000   # periodo del PWM

@cocotb.test()
async def top_test(dut):
    # Inicializar el reloj
    # clk_in = 1 MHz  (periodo 1000 ns)
    cocotb.start_soon(Clock(dut.clk_in, T, units="ns").start())
    # clk_pwm = 1 MHz  (periodo 1000 ns)
    cocotb.start_soon(Clock(dut.clk_pwm, T_PWM, units="ns").start())

    # Resetear el DUT
    dut.rst_in.value = 1
    dut.fcw_in.value = FCW_VALUE
    await RisingEdge(dut.clk_in)
    dut.rst_in.value = 0
    await RisingEdge(dut.clk_in)
    assert dut.nco_out.value == 0, f"Expected 0, got {dut.nco_out.value}"
    assert dut.rst_in.value == 0, f"Expected 0, got {dut.rst_in.value}"
    assert dut.pwm_out.value == 0, f"Expected 0, got {dut.pwm_out.value}"

    max_count = (2**NCO_BITS)

    dut.rst_in.value = 1
    await RisingEdge(dut.clk_in)
    dut.rst_in.value = 0

    with open("sine_table.hex", "r") as f:
        lut_values = [int(line.strip(), 16) for line in f.readlines()]

    samples = []
    nco_samples = []
    tasks = []
    for i in range(0, max_count, FCW_VALUE):
        await RisingEdge(dut.clk_in)
        task = cocotb.start_soon(sample_pwm(dut, 4096))
        tasks.append(task)
        assert dut.data_out.value.integer == lut_values[i]
        nco_samples.append(dut.data_out.value.integer)
        logger.info(f"i: {i} of {max_count}")

    await graph_nco(nco_samples)

    await Combine(*tasks)
    for task in tasks:
        samples.extend(task.result())

    # samples to samples.txt
    with open("samples.txt", "w") as f:
        f.write(samples.__str__())


async def sample_pwm(dut, num_cycles):
    local_samples = []
    for _ in range(num_cycles):
        await RisingEdge(dut.clk_pwm)
        local_samples.append(dut.pwm_out.value.integer)

    return local_samples


async def graph_nco(nco_samples):
    nco_samples = np.array(nco_samples)
    spectrum = np.fft.fft(nco_samples)
    freq = np.fft.fftfreq(len(nco_samples))
    plt.plot(freq[:len(freq)//2], 20*np.log10(np.abs(spectrum[:len(spectrum)//2])))
    plt.title("NCO Spectrum")
    plt.xlabel("Normalized Frequency (fs=1)")
    plt.ylabel("Magnitude (dB)")
    plt.grid()
    plt.savefig("nco_output_spectrum.png")

    plt.close()

    plt.plot(nco_samples)
    plt.title("NCO Output Waveform")
    plt.xlabel("Sample Number")
    plt.ylabel("Amplitude")
    plt.grid()
    plt.savefig("nco_output_waveform.png")
    plt.close()