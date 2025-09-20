module pwm #(
    parameter PWM_BITS = 4
)(
    input clk,
    input [PWM_BITS-1:0] PWM_in,
    output PWM_out
);

reg [PWM_BITS:0] PWM_acc = 0;

always @(posedge clk) PWM_acc <= PWM_acc + PWM_in;

assign PWM_out = PWM_acc[PWM_BITS];
endmodule