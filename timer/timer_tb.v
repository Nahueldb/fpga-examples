`include "timer.v"
`timescale 1ns / 1ps

module tb_timer;

    reg clk;
    reg signal_in;
    wire led_red;
    wire led_green;
    wire led_yellow;
    wire signal_out;

    timer #(
        .CLK_FREQ(12_000_000),
        .TIMER_SET(180)
    ) dut (
        .clk(clk),
        .signal_in(signal_in),
        .led_red(led_red),
        .led_green(led_green),
        .led_yellow(led_yellow),
        .signal_out(signal_out)
    );

    initial begin
        $dumpfile("timer.vcd");
        $dumpvars(0, tb_timer);
    end

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        signal_in = 0;

        #100 signal_in = 1; // Activar señal de entrada

        #500000000; // Esperar 500 ms

        #100 $finish;
    end

endmodule