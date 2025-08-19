`include "bcd7seg.v"
`timescale 1ns / 1ps

module tb_bcd7seg;

    // Declaración de señales
    reg [3:0] bcd_in; // Entrada BCD de 4 bits
    wire [7:0] sseg_out; // Salida para los segmentos del display de 7 segmentos
    wire [3:0] digit_enable; // Salida para habilitar los dígitos (opcional)


    // Instanciamos el DUT (Device Under Test)
    bcd7seg dut (
        .bcd_in(bcd_in),
        .sseg_out(sseg_out),
        .digit_enable(digit_enable)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("bcd7seg.vcd");
        $dumpvars(0, tb_bcd7seg
    );
    end

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        bcd_in = 4'b0000; // Comenzamos con 0
        #100 bcd_in = 4'b0001; // Caso 1
        #100 bcd_in = 4'b0010; // Caso 2
        #100 bcd_in = 4'b0011; // Caso 3
        #100 bcd_in = 4'b0100; // Caso 4
        #100 bcd_in = 4'b0101; // Caso 5
        #100 bcd_in = 4'b0110; // Caso 6
        #100 bcd_in = 4'b0111; // Caso 7
        #100 bcd_in = 4'b1000; // Caso 8
        #100 bcd_in = 4'b1001; // Caso 9
        #100 bcd_in = 4'b1010; // Caso no válido, todos los segmentos apagados
        #100 bcd_in = 4'b1111; // Caso no válido, todos los segmentos apagados
        #100 bcd_in = 4'b0000; // Volvemos a 0

        // Finalizamos la simulación
        #100 $finish;
    end

endmodule