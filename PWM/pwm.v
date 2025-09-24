module pwm #(
    parameter PWM_BITS = 12
)(
    input wire rst_in,
    input wire clk_pwm,
    input wire [PWM_BITS-1:0] pwm_in,
    output wire pwm_out
);

reg [PWM_BITS:0] pwm_acc = {PWM_BITS+1{1'b0}};

always @(posedge clk_pwm) begin
    if (rst_in)
        pwm_acc <= {PWM_BITS+1{1'b0}};
    else
        pwm_acc <= pwm_acc + pwm_in;
end

assign pwm_out = pwm_acc[PWM_BITS];
endmodule