`include "and.v"
`timescale 1ns / 1ps

module tb_and;

    // Declaración de señales
    reg a_in;
    reg b_in;
    wire q_out;

    // Instanciamos el DUT (Device Under Test)
    and_2 dut (
        .a_in(a_in),
        .b_in(b_in),
        .q_out(q_out)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("and.vcd");
        $dumpvars(0, tb_and);
    end

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        a_in = 0; b_in = 0;

        // Cambios en las señales para probar el circuito
        #100 a_in = 1; b_in = 0; // Caso 1
        #100 a_in = 0; b_in = 1; // Caso 2
        #100 a_in = 1; b_in = 1; // Caso 3
        #100 a_in = 0; b_in = 0; // Caso 4

        // Finalizamos la simulación
        #100 $finish;
    end

endmodule
