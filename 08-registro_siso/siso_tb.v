`include "siso.v"
`timescale 1ns / 1ps


module siso_tb;
    // Declaración de señales
    reg d_in;
    wire q_out;
    reg out_enable_in;
    reg rst;
    reg clk = 0;

    reg [3:0] d_reg = 4'b1001; // Registro interno para verificar el estado
    integer i;

    siso #(
        .DATA_WIDTH(4),
        .CLOCK_EDGE(1)
    ) dut (
        .d_in(d_in),
        .q_out(q_out),
        .out_enable_in(out_enable_in),
        .rst(rst),
        .clk(clk)
    );

    always #10 clk = ~clk;

    initial begin
        $dumpfile("siso.vcd");
        $dumpvars(0, siso_tb);
    end

    initial begin
        out_enable_in = 1;
        rst = 0;

        #20 
        for (i = 0; i < 4; i = i + 1) begin
            d_in = d_reg[i];
            #20; // Espera para permitir que el registro se actualice
        end
        d_in = 0; // Enviar un valor de 0 al final
        #80
        rst = 1; // Activar el reset
        #20;
        rst = 0; // Desactivar el reset
        out_enable_in = 0; // Desactivar la salida

        #40 $finish;
    end
endmodule