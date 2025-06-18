// blink_tb.v
// Testbench para el módulo blink_led
// Este testbench simula un reloj de 50 MHz y verifica el parpadeo del LED
// SPDX-License-Identifier: GPL-3.0

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