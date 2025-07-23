`include "contador_universal.v"
`include "bcd7seg.v"

module contador_display #(
    parameter N = 4,
    parameter MOD = 16,
    parameter CLK_EDGE = 1
)(
    input wire clk,
    input wire rst,
    input wire load_in,
    input wire [N-1:0] d_in,
    input wire out_enable_in,
    input wire counter_enable_in,
    input wire count_up_in,
    // input wire clk_edge_in,
    output wire terminal_count_out,
    output wire [6:0] sseg_out,
    output wire [3:0] digit_enable
);

    wire [N-1:0] contador_out;

    // Instancia del contador universal
    contador_universal #(
        .N(N),
        .MOD(MOD),
        .CLK_EDGE(CLK_EDGE)
    ) contador_inst (
        .clk(clk),
        .rst(rst),
        .load_in(load_in),
        .d_in(d_in),
        .out_enable_in(out_enable_in),
        .counter_enable_in(counter_enable_in),
        .count_up_in(count_up_in),
        // .clk_edge_in(clk_edge_in),
        .q_out(contador_out),
        .terminal_count_out(terminal_count_out)
    );

    // Instancia del decodificador BCD a display 7 segmentos
    bcd7seg display_inst (
        .bcd_in(contador_out),
        .sseg_out(sseg_out),
        .digit_enable(digit_enable)
    );

endmodule
