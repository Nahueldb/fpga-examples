module nco #(
    parameter NCO_BITS = 10
)(
    input wire rst_in,
    input wire clk_in,
    output wire [NCO_BITS-1:0] nco_out
);
    reg [NCO_BITS-1:0] nco_cnt;

    always @ (posedge clk_in or posedge rst_in) begin
        if (rst_in) begin
            nco_cnt <= {NCO_BITS{1'b0}};
        end else begin
            nco_cnt <= nco_cnt + 1; // Increment NCO output by frequency control word
        end
    end

    assign nco_out = nco_cnt;

endmodule