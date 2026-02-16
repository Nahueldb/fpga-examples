`include "pwm.v"
`include "spi_master.v"

module top (
    input wire clk_in,
    input wire rst_in,
    input wire ssel_in,
    output wire [11:0] d_reg_master,
    output wire pwm_out,
    output wire mem_clk_out
);
    // Parámetros
    parameter DATA_OUT_BITS = 12;

    // Salidas intermedias
    wire [DATA_OUT_BITS-1:0] data_out;
    wire sck;
    wire ssel;
    wire miso;

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
        .d_reg_master(d_reg_master)
    );
    // Instancia del PWM
    pwm #(
        .PWM_BITS(DATA_OUT_BITS)
    ) pwm_inst (
        .rst_in(rst_in),
        .clk_pwm(clk_in), // Usamos el clk_in como reloj para el PWM
        .pwm_in(data_out), // Usamos los 12 bits para el PWM
        .pwm_out(pwm_out)
    );

    initial begin
        $dumpfile("top_wave.vcd");
        $dumpvars(0, top);
    end

endmodule