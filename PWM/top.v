`include "nco.v"
`include "lut.v"
`include "pwm.v"

module top (
    input wire clk_in,
    input wire rst_in,
    input wire [3:0] fcw_in, // Frequency control word input
    output wire pwm_out,
    output wire mem_clk_out
);
    // Parámetros
    parameter NCO_FREQ_BITS = 8;
    parameter ADDR_BITS = 10;
    parameter DATA_OUT_BITS = 12;

    // Salidas intermedias
    wire [NCO_FREQ_BITS-1:0] nco_out;
    wire [ADDR_BITS-1:0] addr;
    wire [DATA_OUT_BITS-1:0] data_out;

    // Instancia del NCO para la frecuencia
    nco #(
        .NCO_BITS(NCO_FREQ_BITS)
    ) nco_freq (
        .rst_in(rst_in),
        .clk_in(clk_in),
        .nco_out(nco_out)
    );
    assign mem_clk_out = nco_out[NCO_FREQ_BITS-1]; // Salida del bit más significativo del NCO

    // Instancia del NCO para la dirección
    nco #(
        .NCO_BITS(ADDR_BITS)
    ) nco_addr (
        .rst_in(rst_in),
        .clk_in(nco_out[NCO_FREQ_BITS-1]), // Usamos el bit más significativo del primer NCO como reloj
        .nco_out(addr)
    );

    // Instancia de la LUT
    lut #(
        .ADDR_BITS(ADDR_BITS),
        .DATA_OUT_BITS(DATA_OUT_BITS)
    ) lut_inst (
        .addr_in(addr[ADDR_BITS-1:0]), // Usamos los bits menos significativos como dirección
        .data_out(data_out),
        .clk_in(clk_in) // Usamos el clk_in como reloj para la LUT
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

endmodule