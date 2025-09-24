`include "nco.v"
`include "lut.v"
`include "pwm.v"

module top (
    input wire clk_in,
    input wire clk_pwm,
    input wire rst_in,
    input wire [3:0] fcw_in, // Frequency control word input
    output wire pwm_out
);

    wire [9:0] nco_out;

    wire [11:0] data_out;

    // Instancia del NCO
    nco #(
        .NCO_BITS(10),
        .NCO_FREQ_BITS(4)
    ) nco_inst (
        .rst_in(rst_in),
        .clk_in(clk_in),
        .fcw_in(fcw_in),
        .nco_out(nco_out)
    );

    // Instancia de la LUT
    lut #(
        .ADDR_BITS(10)
    ) lut_inst (
        .addr_in(nco_out),
        .data_out(data_out)
    );

    // Instancia del PWM
    pwm #(
        .PWM_BITS(12)
    ) pwm_inst (
        .rst_in(rst_in),
        .clk_pwm(clk_pwm),
        .pwm_in(data_out), // Usamos los 12 bits para el PWM
        .pwm_out(pwm_out)
    );

endmodule