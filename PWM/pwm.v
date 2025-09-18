module PWM #(
    parameter PWM_BITS = 4,
)(
    input clk,
    input [PWM_BITS-1:0] PWM_in,
    output PWM_out
);

reg [PWM_BITS-1:0] cnt;
always @(posedge clk) cnt <= cnt + 1'b1;  // free-running counter

assign PWM_out = (PWM_in > cnt);  // comparator
endmodule