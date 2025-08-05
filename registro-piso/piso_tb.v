`include "piso.v"
`timescale 1ns / 1ps


module piso_tb;
    // Declaración de señales
    reg [3:0] d_in;
    wire q_out;
    reg out_enable_in;
    reg rst;
    reg clk = 0;
    reg clk_enable;
    reg load_enable_in;

    reg [3:0] d_reg = 4'b1001; // Registro interno para verificar el estado
    integer i;

    piso #(
        .DATA_WIDTH(4),
        .CLOCK_EDGE(1)
    ) dut (
        .d_in(d_in),
        .q_out(q_out),
        .out_enable_in(out_enable_in),
        .rst(rst),
        .clk(clk),
        .clk_enable(clk_enable),
        .load_enable_in(load_enable_in)
    );

    always #10 clk = ~clk;

    initial begin
        $dumpfile("piso.vcd");
        $dumpvars(0, piso_tb);
    end

    initial begin
        out_enable_in = 1;
        clk_enable = 1;
        rst = 1;
        #20 rst = 0; // Desactivar el reset
        load_enable_in = 1;
        d_in = d_reg; // Cargar el registro con el valor inicial
        #20;
        load_enable_in = 0;
        #240
        rst = 1; // Activar el reset
        #20;
        rst = 0; // Desactivar el reset
        out_enable_in = 0; // Desactivar la salida

        #40 $finish;
    end
endmodule