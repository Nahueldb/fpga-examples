`include "mux8chNbits.v"
`timescale 1ns / 1ps

module tb_mux8chNbits;

    // Declaración de señales
    reg [2:0] sel_in;
    reg [3:0] data_in_0, data_in_1, data_in_2, data_in_3, data_in_4, data_in_5, data_in_6, data_in_7;
    wire [3:0] data_out;

    // Instanciamos el DUT (Device Under Test)
    mux8chNbits #(.N(4)) dut (
        .sel_in(sel_in),
        .data_in_0(data_in_0),
        .data_in_1(data_in_1),
        .data_in_2(data_in_2),
        .data_in_3(data_in_3),
        .data_in_4(data_in_4),
        .data_in_5(data_in_5),
        .data_in_6(data_in_6),
        .data_in_7(data_in_7),
        .data_out(data_out)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("mux8chNbits.vcd");
        $dumpvars(0, tb_mux8chNbits);
    end

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        sel_in = 3'b000;
        data_in_0 = 4'b0000;
        data_in_1 = 4'b0001;
        data_in_2 = 4'b0010;
        data_in_3 = 4'b0011;
        data_in_4 = 4'b0100;
        data_in_5 = 4'b0101;
        data_in_6 = 4'b0110;
        data_in_7 = 4'b0111;

        #10; // Esperar un tiempo para observar la salida

        sel_in = 3'b001; // Seleccionar canal 1
        #10;

        sel_in = 3'b010; // Seleccionar canal 2
        #10;

        sel_in = 3'b011; // Seleccionar canal 3
        #10;

        sel_in = 3'b100; // Seleccionar canal 4
        #10;

        sel_in = 3'b101; // Seleccionar canal 5
        #10;

        sel_in = 3'b110; // Seleccionar canal 6
        #10;

        sel_in = 3'b111; // Seleccionar canal 7
        #10;

        sel_in = 3'b000; // Volver al canal 0
        #10;
    end
endmodule