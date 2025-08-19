# Oscilador Controlado Numericamente (NCO)

- [NCO](#nco)
  - [Descripcion](#descripcion)
  - [Codigo](#codigo)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)
    - [Testbench en Python (Cocotb)](#testbench-en-python-cocotb)

## Descripcion

El NCO (Numerically Controlled Oscillator) es un tipo de oscilador que utiliza un contador digital y este contador es incrementado por un valor de frecuencia de control (Frequency Control Word, FCW).

## Codigo

### Verilog

```verilog
module nco #(
    parameter NCO_BITS = 4,
    parameter NCO_FREQ_BITS = 4 // Number of bits for frequency control word
)(
    input wire rst_in,
    input wire clk_in,
    input wire [NCO_FREQ_BITS-1:0] fcw_in, // Frequency control word input
    output wire [NCO_BITS-1:0] nco_out
);
    reg [NCO_BITS-1:0] nco_cnt;

    always @ (posedge clk_in or posedge rst_in) begin
        if (rst_in) begin
            nco_cnt <= {NCO_BITS{1'b0}};
        end else begin
            nco_cnt <= nco_cnt + fcw_in; // Increment NCO output by frequency control word
        end
    end

    assign nco_out = nco_cnt;
```

## Simulacion

### Testbench en verilog

```verilog
`include "nco.v"
`timescale 1ns / 1ps


module nco_tb #(
    parameter NCO_BITS = 4,
    parameter NCO_FREQ_BITS = 4 // Number of bits for frequency control word
);

    reg clk_in = 0;
    reg rst_in;
    reg [NCO_FREQ_BITS-1:0] fcw_in;
    wire [NCO_BITS-1:0] nco_out;

    nco dut (
        .clk_in(clk_in),
        .rst_in(rst_in),
        .fcw_in(fcw_in),
        .nco_out(nco_out)
    );

    initial begin
        $dumpfile("nco.vcd");
        $dumpvars(0, nco_tb);
    end

    always #10 clk_in = ~clk_in;
    initial begin
        // Initialize signals
        rst_in = 1;
        fcw_in = {NCO_FREQ_BITS{1'b0}};

        #20 rst_in = 0; // Release reset

        #20 fcw_in = 4'b0001; // Set frequency control word

        #300 fcw_in = 4'b0010; // Change frequency control word

        #200 fcw_in = 4'b0100; // Change frequency control word again

        #100 $finish; // End simulation
    end
endmodule
```

### Testbench en Python (Cocotb)

```python
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
```
