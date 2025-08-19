`include "contador_universal.v"
`timescale 1ns / 1ps

module tb_contador_universal;

    // Declaración de señales
    reg clk = 0;
    reg rst;
    reg load_in;
    reg [3:0] d_in;
    reg out_enable_in;
    reg counter_enable_in;
    reg count_up_in;
    wire [3:0] q_out;
    wire terminal_count_out;

    // Instanciamos el DUT (Device Under Test)
    contador_universal #(
        .N(4),
        .MOD(16),
        .CLK_EDGE(1)
    ) dut (
        .clk(clk),
        .rst(rst),
        .load_in(load_in),
        .d_in(d_in),
        .out_enable_in(out_enable_in),
        .counter_enable_in(counter_enable_in),
        .count_up_in(count_up_in),
        .q_out(q_out),
        .terminal_count_out(terminal_count_out)
    );

    always #10 clk = ~clk; // Generador de reloj: 50 MHz → período de 20 ns

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("contador_universal.vcd");
        $dumpvars(0, tb_contador_universal);
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