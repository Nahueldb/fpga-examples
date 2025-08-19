`include "pipo.v"
`timescale 1ns / 1ps


module pipo_tb;
    // Declaración de señales
    reg [7:0] d_in;
    wire [7:0] q_out;
    reg out_enable_in;
    reg rst;
    reg clk = 0;
    reg clk_enable;

    pipo #(
        .DATA_WIDTH(8),
        .CLOCK_EDGE(1)
    ) dut (
        .d_in(d_in),
        .q_out(q_out),
        .out_enable_in(out_enable_in),
        .rst(rst),
        .clk(clk),
        .clk_enable(clk_enable)
    );

    always #10 clk = ~clk;

    initial begin
        $dumpfile("pipo.vcd");
        $dumpvars(0, pipo_tb);
    end

    initial begin
        clk_enable = 1;
        out_enable_in = 1;
        rst = 0;

        #20 d_in = 8'b10101010;

        #20 clk_enable = 0;
        d_in = 8'b00000000;

        #80 clk_enable = 1;
        d_in = 8'b11110000;

        #20 clk_enable = 0;

        #20 rst = 1;

        #40 out_enable_in = 0;

        #40 $finish;
    end
endmodule