import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ReadOnly
from pyparsing import Combine

T = 83.33
DATA_OUT_BITS = 12

@cocotb.test()
async def top_test(dut):
    logger = dut._log
    cocotb.start_soon(Clock(dut.clk_in, T, units="ns").start())

    with open("audio_table.hex", "r") as f:
        audio_values = [int(line.strip(), 16) for line in f.readlines()]
    samples = []
    tasks = []

    # Reset
    dut.rst_in.value = 1
    await RisingEdge(dut.clk_in)
    dut.rst_in.value = 0
    await RisingEdge(dut.clk_in)

    for audio_value in audio_values[:20]:
        await FallingEdge(dut.ssel_out)
        for i in range(DATA_OUT_BITS):
            bit = (audio_value >> (DATA_OUT_BITS - 1 - i)) & 1
            dut.miso.value = bit
            await RisingEdge(dut.clk_in)
        await ReadOnly()
        assert dut.d_reg_master.value == audio_value, f"Expected {audio_value}, got {dut.d_reg_master.value}"

    #     task = cocotb.start_soon(sample_pwm(dut, audio_value))
    #     tasks.append(task)

    # await Combine(*tasks)
    # for task in tasks:
    #     try:
    #         samples.extend(task.result())
    #     except Exception as e:
    #         logger.error(f"Error in task: {e}")


async def sample_pwm(dut, audio_value):
    local_samples = []
    assert dut.data_out == audio_value, f"Expected {audio_value}, got {dut.data_out.value}"
    for _ in range(2*DATA_OUT_BITS):
        await RisingEdge(dut.clk_in)
        local_samples.append(dut.pwm_out.value.integer)

    return local_samples

