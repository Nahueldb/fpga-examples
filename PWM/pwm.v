module pwm #(
    parameter PWM_BITS = 12
)(
    input wire rst_in,
    input wire clk_pwm,
    input wire [PWM_BITS-1:0] pwm_in,
    output wire pwm_out
);

// reg [PWM_BITS:0] pwm_acc = {PWM_BITS+1{1'b0}};
reg [PWM_BITS-1:0] cnt;

always @(posedge clk_pwm) begin
    if (rst_in)
        cnt <= 0;
    else
        cnt <= cnt + 1;
end

assign pwm_out = (cnt < pwm_in) ? 1'b1 : 1'b0;
endmodule