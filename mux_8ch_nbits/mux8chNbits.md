# Multiplexor de 8 canales N bits

- [Multiplexor de 8 canales N bits](#multiplexor-de-8-canales-n-bits)
  - [Descripcion](#descripcion)
  - [Código](#código)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)
    - [Testbench en Python (Cocotb)](#testbench-en-python-cocotb)

## Descripcion

Un multiplexor de 8 canales N bits es un circuito que selecciona una de las 8 entradas de datos de N bits y la dirige a la salida, basado en una señal de selección de 3 bits. Este tipo de multiplexor es útil para manejar múltiples fuentes de datos y seleccionar una de ellas para su procesamiento.

## Código

### Verilog

```verilog
module mux8chNbits #(
    parameter N = 4 // Number of bits per channel
    )(
    input wire [2:0] sel_in,
    input wire [N-1:0] data_in_0,
    input wire [N-1:0] data_in_1,
    input wire [N-1:0] data_in_2,
    input wire [N-1:0] data_in_3,
    input wire [N-1:0] data_in_4,
    input wire [N-1:0] data_in_5,
    input wire [N-1:0] data_in_6,
    input wire [N-1:0] data_in_7,
    output reg [N-1:0] data_out
);
    always @(*) begin
        case (sel_in)
            3'b000: data_out = data_in_0;
            3'b001: data_out = data_in_1;
            3'b010: data_out = data_in_2;
            3'b011: data_out = data_in_3;
            3'b100: data_out = data_in_4;
            3'b101: data_out = data_in_5;
            3'b110: data_out = data_in_6;
            3'b111: data_out = data_in_7;
            default: data_out = {N{1'b0}}; // Default case to avoid latches
        endcase
    end
endmodule
```

## Simulacion

### Testbench en verilog

```verilog
`include "mux8chNbits.v"
`timescale 1ns / 1ps

module tb_mux8chNbits;

    // Declaración de señales
    reg [2:0] sel_in;
    reg [3:0] data_in_0, data_in_1, data_in_2, data_in_3, data_in_4, data_in_5, data_in_6, data_in_7;
    wire [3:0] data_out;

    // Instanciamos el DUT (Device Under Test)
    mux8chNbits #(.N(4)) dut (
        .sel_in(sel_in),
        .data_in_0(data_in_0),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .data_in_3(data_in_3),
        .data_in_4(data_in_4),
        .data_in_5(data_in_5),
        .data_in_6(data_in_6),
        .data_in_7(data_in_7),
        .data_out(data_out)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("mux8chNbits.vcd");
        $dumpvars(0, tb_mux8chNbits);
    end

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        sel_in = 3'b000;
        data_in_0 = 4'b0000;
        data_in_1 = 4'b0001;
        data_in_2 = 4'b0010;
        data_in_3 = 4'b0011;
        data_in_4 = 4'b0100;
        data_in_5 = 4'b0101;
        data_in_6 = 4'b0110;
        data_in_7 = 4'b0111;

        #10; // Esperar un tiempo para observar la salida

        sel_in = 3'b001; // Seleccionar canal 1
        #10;

        sel_in = 3'b010; // Seleccionar canal 2
        #10;

        sel_in = 3'b011; // Seleccionar canal 3
        #10;

        sel_in = 3'b100; // Seleccionar canal 4
        #10;

        sel_in = 3'b101; // Seleccionar canal 5
        #10;

        sel_in = 3'b110; // Seleccionar canal 6
        #10;

        sel_in = 3'b111; // Seleccionar canal 7
        #10;

        sel_in = 3'b000; // Volver al canal 0
        #10;
    end
endmodule
```

### Testbench en Python (Cocotb)

```python
import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def mux8chNbits_tb(dut):
    """Testbench for the MUX 8 Channels N Bits."""

    dut.data_in_0.value = 0b000
    dut.data_in_1.value = 0b001
    dut.data_in_2.value = 0b010
    dut.data_in_3.value = 0b011
    dut.data_in_4.value = 0b100
    dut.data_in_5.value = 0b101
    dut.data_in_6.value = 0b110
    dut.data_in_7.value = 0b111

    await Timer(1, units='ns')

    for i in range(8):
        dut.sel_in.value = i
        await Timer(10, units='ns')  # Wait for some time to simulate clock
        # Check if the output matches the expected value
        expected_output = i
        assert dut.data_out.value == expected_output, f"Output mismatch: expected {expected_output}, got {dut.data_out.value}"
```
