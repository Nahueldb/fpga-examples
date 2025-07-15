# Flip-Flop D

- [Flip-Flop D](#flip-flop-d)
  - [Descripcion](#descripcion)
    - [Tabla de verdad](#tabla-de-verdad)
  - [Codigo](#codigo)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)
    - [Testbench en Python (Cocotb)](#testbench-en-python-cocotb)

## Descripcion

El Flip-Flop D es un tipo de circuito secuencial que captura el valor de la entrada D en el flanco de subida del reloj (clk) y lo mantiene en la salida Q hasta el siguiente flanco de subida. Es ampliamente utilizado para almacenar datos en sistemas digitales.

### Tabla de verdad

| Entrada D | Entrada clk | Salida Q |
|-----------|-------------|----------|
|     0     |      ↑      |    0     |
|     0     |      ↓      |    0     |
|     1     |      ↑      |    1     |
|     1     |      ↓      |    1     |

## Codigo

### Verilog

```verilog
module ffd (
    input wire d_in,
    input wire clk,
    input wire rst_in,
    output reg q_out
);

    always @(posedge clk) begin
        if (rst_in) begin
            q_out <= 0;
        end else begin
            q_out <= d_in;
        end
    end

endmodule
```

## Simulacion

### Testbench en verilog

```verilog
`include "flipflopD.v"
`timescale 1ns / 1ps

module tb_flipflopD;

    // Declaración de señales
    reg clk = 0;          // Reloj
    reg rst_in;        // Reset asíncrono
    reg d_in;           // Entrada D
    wire q_out;          // Salida Q

    // Instanciamos el DUT (Device Under Test)
    ffd dut (
        .clk(clk),
        .rst_in(rst_in),
        .d_in(d_in),
        .q_out(q_out)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("flipflopD.vcd");
        $dumpvars(0, tb_flipflopD);
    end

    // Generador de reloj: 50 MHz → período de 20 ns
    always #10 clk = ~clk;

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        rst_in = 1; d_in = 0; // Reset activo, salida debe ser 0
        #20 rst_in = 0; // Desactivamos el reset

        // Cambios en las señales para probar el circuito
        #20 d_in = 1; // Entrada D en 1, salida Q debe ser 1
        #20 d_in = 0; // Entrada D en 0, salida Q debe ser 0
        #20 d_in = 1; // Entrada D en 1, salida Q debe ser 1
        #20 d_in = 0; // Entrada D en 0, salida Q debe ser 0

        // Activamos el reset nuevamente
        #20 rst_in = 1; // Reset activo, salida debe ser 0
        #20 rst_in = 0; // Desactivamos el reset

        // Finalizamos la simulación
        #100 $finish;
        
    end
endmodule
```

### Testbench en Python (Cocotb)

```python
import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

@cocotb.test()
async def flipflopD_tb(dut):
    """Testbench for the FLIP FLOP D."""
    
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.start_soon(clock.start())

    dut.rst_in.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)  # Wait for two clock cycles to ensure reset is applied
    assert dut.q_out.value.integer == 0, "Q should be 0 after reset"

    dut.rst_in.value = 0
    dut.d_in.value = 0
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.q_out.value.integer == 0, "Q should be 0"

    dut.d_in.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.q_out.value.integer == 1, "Q should be 1 after D is set to 1 on clock edge"

    dut.rst_in.value = 1
    await RisingEdge(dut.clk)
    await RisingEdge(dut.clk)
    assert dut.q_out.value.integer == 0, "Q should be reset to 0 after reset signal is high"
```
