`include "flipflopD.v"
`timescale 1ns / 1ps

module tb_flipflopD;

    // Declaración de señales
    reg clk = 0;          // Reloj
    reg rst_in;        // Reset asíncrono
    reg d_in;           // Entrada D
    wire q_out;          // Salida Q

    // Instanciamos el DUT (Device Under Test)
    ffd dut (
        .clk(clk),
        .rst_in(rst_in),
        .d_in(d_in),
        .q_out(q_out)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("flipflopD.vcd");
        $dumpvars(0, tb_flipflopD);
    end

    // Generador de reloj: 50 MHz → período de 20 ns
    always #10 clk = ~clk;

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        rst_in = 1; d_in = 0; // Reset activo, salida debe ser 0
        #20 rst_in = 0; // Desactivamos el reset

        // Cambios en las señales para probar el circuito
        #20 d_in = 1; // Entrada D en 1, salida Q debe ser 1
        #20 d_in = 0; // Entrada D en 0, salida Q debe ser 0
        #20 d_in = 1; // Entrada D en 1, salida Q debe ser 1
        #20 d_in = 0; // Entrada D en 0, salida Q debe ser 0

        // Activamos el reset nuevamente
        #20 rst_in = 1; // Reset activo, salida debe ser 0
        #20 rst_in = 0; // Desactivamos el reset

        // Finalizamos la simulación
        #100 $finish;
        
    end
endmodule