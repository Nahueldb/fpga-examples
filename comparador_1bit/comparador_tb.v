`include "comparador.v"
`timescale 1ns / 1ps

module tb_comparador;

    // Declaración de señales
    reg a;
    reg b;
    wire eq;
    wire gt;
    wire lt;

    // Instanciamos el DUT (Device Under Test)
    comparador dut (
        .a(a),
        .b(b),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("comparador.vcd");
        $dumpvars(0, tb_comparador);
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
