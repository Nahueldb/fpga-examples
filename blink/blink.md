# Blink

- [Blink](#blink)
  - [Descripcion](#descripcion)
  - [Codigo](#codigo)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)
    - [Testbench en Python (Cocotb)](#testbench-en-python-cocotb)

## Descripcion

El circuito "blink_led" es un ejemplo clásico en diseño digital que hace parpadear un LED a intervalos regulares. Este circuito utiliza un contador para generar una señal de reloj que alterna el estado del LED.

## Codigo

### Verilog

```verilog
module blink_led (
    input wire clk,
    output reg led = 0  // ✅ Inicializado a 0
);

    parameter COUNT_MAX = 1_000_000;

    reg [24:0] counter = 0;

    always @(posedge clk) begin
        if (counter == COUNT_MAX - 1) begin
            counter <= 0;
            led <= ~led;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule
```

## Simulacion

### Testbench en verilog

```verilog
`include "blink.v"
`timescale 1ns / 1ps

module tb_blink_led;

    reg clk = 0;
    wire led;

    // Instanciamos el DUT (Device Under Test)
    blink_led dut (
        .clk(clk),
        .led(led)
    );

    // Generador de reloj: 50 MHz → período de 20 ns
    always #10 clk = ~clk;

    initial begin
        // Dump de señales para GTKWave
        $dumpfile("blink.vcd");
        $dumpvars(0, tb_blink_led);

        // Tiempo de simulación
        #1_000_000;
        $finish;
    end

endmodule
```

### Testbench en Python (Cocotb)

```python
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

COUNT_MAX = 10  # Adjusted for testing purposes

@cocotb.test()
async def blink_tb(dut):
    """Testbench for the BLINK."""
    # simulate the clock
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.start_soon(clock.start())

    initial_led = dut.led.value.integer
    assert initial_led == 0, f"Initial LED value should be 0, got {initial_led}"

    # Wait for the first clock edge
    for _ in range(COUNT_MAX + 1): # Wait for enough clock cycles to toggle the LED
        await RisingEdge(dut.clk)
    assert dut.led.value.integer == 1, "LED should toggle after first clock edge"
```
