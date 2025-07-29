`include "contador_display.v"
`timescale 1ns / 1ps

module tb_contador_display;

    // Parámetros
    parameter N = 4;
    parameter MOD = 16;
    parameter CLK_EDGE = 1;

    // Señales de prueba
    reg clk = 0;
    reg rst;
    reg load_in;
    reg [N-1:0] d_in;
    reg out_enable_in;
    reg counter_enable_in;
    reg count_up_in;
    // reg clk_edge_in;
    wire terminal_count_out;
    wire [6:0] sseg_out;
    wire [3:0] digit_enable;


    wire [N-1:0] contador_out;

    // Instancia del contador display
    contador_display #(
        .N(N),
        .MOD(MOD),
        .CLK_EDGE(CLK_EDGE)
    ) dut (
        .clk(clk),
        .rst(rst),
        .load_in(load_in),
        .d_in(d_in),
        .out_enable_in(out_enable_in),
        .counter_enable_in(counter_enable_in),
        .count_up_in(count_up_in),
        // .clk_edge_in(clk_edge_in),
        .terminal_count_out(terminal_count_out),
        .sseg_out(sseg_out),
        .digit_enable(digit_enable)
    );
    

    always #10 clk = ~clk; // Generador de reloj: 50 MHz → período de 20 ns

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("contador_display.vcd");
        $dumpvars(0, tb_contador_display);
    end

    // Estímulo inicial
    initial begin
        // Valores iniciales
        load_in = 0;
        d_in = 4'b0000;
        out_enable_in = 1;
        counter_enable_in = 1;
        count_up_in = 1;

        #60 rst = 1;
        // Liberar el reset
        #15 rst = 0;

        // Cargar un valor
        #20 load_in = 1; d_in = 4'b1010;
        #20 load_in = 0;

        // Deshabilitar el contador
        #80 count_up_in = 0;

        // Finalizar la simulación
        #60 $finish;
    end

endmodule
