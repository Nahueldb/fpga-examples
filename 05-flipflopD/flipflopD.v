module ffd (
    input wire d_in,
    input wire clk,
    input wire rst_in,
    output reg q_out
);

    always @(posedge clk) begin
        if (rst_in) begin
            q_out <= 0;
        end else begin
            q_out <= d_in;
        end
    end

endmodule
