`include "comparador_nbits.v"
`timescale 1ns / 1ps

module tb_comparador_nbits;

    // Declaración de señales
    reg [1:0] a_in ; // Cambiar el tamaño según N
    reg [1:0] b_in; // Cambiar el tamaño según N
    wire gt_out;
    wire lt_out;
    wire eq_out;

    // Instanciamos el DUT (Device Under Test)
    comparador_nbits dut (
        .a_in(a_in),
        .b_in(b_in),
        .gt_out(gt_out),
        .lt_out(lt_out),
        .eq_out(eq_out)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("comparador_nbits.vcd");
        $dumpvars(0, tb_comparador_nbits);
    end

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        a_in = 2'b00;
        b_in = 2'b00;
        #10;
        a_in = 2'b01; // a_in < b_in
        b_in = 2'b10;
        #10;
        a_in = 2'b10; // a_in > b_in
        b_in = 2'b01;
        #10;
        a_in = 2'b11; // a_in == b_in
        b_in = 2'b11;
        #10;
    end

endmodule
