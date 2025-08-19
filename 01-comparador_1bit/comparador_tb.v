`include "comparador.v"
`timescale 1ns / 1ps

module tb_comparador;

    // Declaración de señales
    reg a_in;
    reg b_in;
    wire eq_out;
    wire gt_out;
    wire lt_out;

    // Instanciamos el DUT (Device Under Test)
    comparador dut (
        .a_in(a_in),
        .b_in(b_in),
        .eq_out(eq_out),
        .gt_out(gt_out),
        .lt_out(lt_out)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("comparador.vcd");
        $dumpvars(0, tb_comparador);
    end

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        a_in = 0; b_in = 0;

        // Cambios en las señales para probar el circuito
        #100 a_in = 1; b_in = 0;
        #100 a_in = 0; b_in = 1;
        #100 a_in = 1; b_in = 1;
        #100 a_in = 0; b_in = 0;

        // Finalizamos la simulación
        #100 $finish;
    end

endmodule
