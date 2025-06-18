`include "and.v"
`timescale 1ns / 1ps

module tb_and;

    // Declaración de señales
    reg a;
    reg b;
    wire q;

    // Instanciamos el DUT (Device Under Test)
    and_2 dut (
        .a(a),
        .b(b),
        .q(q)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("and.vcd");
        $dumpvars(0, tb_and);
    end

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        a = 0; b = 0;

        // Cambios en las señales para probar el circuito
        #100 a = 1; b = 0; // Caso 1
        #100 a = 0; b = 1; // Caso 2
        #100 a = 1; b = 1; // Caso 3
        #100 a = 0; b = 0; // Caso 4

        // Finalizamos la simulación
        #100 $finish;
    end

endmodule
