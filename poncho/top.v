`include "pwm.v"
`include "spi_master.v"
`include "fifo.v"

module top (
    input wire clk_in,
    input wire rst_in,
    input wire ssel_in,
    output wire [11:0] d_reg_master,
    output wire pwm_out
);
    // Parámetros
    parameter DATA_OUT_BITS = 12;

    // Salidas intermedias
    wire [DATA_OUT_BITS-1:0] data_out;
    wire sck;
    wire ssel;
    wire miso;
    wire sample_valid;
    wire pwm_period_done;

    // Instancia del SPI Master
    spi_master #(
        .DATA_WIDTH(DATA_OUT_BITS)
    ) master_inst (
        .clk(clk_in),
        // .mosi(mosi),
        .miso(miso),
        .ssel_in(ssel_in),
        .sck(sck),
        .ssel(ssel),
        .d_reg_master(d_reg_master),
        .sample_valid(sample_valid)
    );

    // Instancia de la FIFO
    fifo #(
        .DATA_WIDTH(DATA_OUT_BITS),
        .FIFO_DEPTH(16) // Profundidad de la FIFO
    ) fifo_inst (
        .clk(clk_in),
        .rst(rst_in),
        .wr_en(sample_valid), // Escribimos en la FIFO cuando hay una muestra válida
        .rd_en(pwm_period_done), // Leemos de la FIFO al finalizar un período del PWM
        .data_in(d_reg_master),
        .data_out(data_out),
        .full(),
        .empty()
    );

    // Instancia del PWM
    pwm #(
        .PWM_BITS(DATA_OUT_BITS)
    ) pwm_inst (
        .rst_in(rst_in),
        .clk_pwm(clk_in),
        .pwm_in(data_out),
        .pwm_out(pwm_out),
        .pwm_period_done(pwm_period_done)
    );

    initial begin
        $dumpfile("top_wave.vcd");
        $dumpvars(0, top);
    end

endmodule