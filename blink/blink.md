# Blink

- [Blink](#blink)
  - [Descripcion](#descripcion)
  - [Codigo](#codigo)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)

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
