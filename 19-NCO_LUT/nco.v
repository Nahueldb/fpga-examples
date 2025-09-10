module nco #(
    parameter NCO_BITS = 10,
    parameter NCO_FREQ_BITS = 4 // Number of bits for frequency control word
)(
    input wire rst_in,
    input wire clk_in,
    input wire [NCO_FREQ_BITS-1:0] fcw_in, // Frequency control word input
    output wire [NCO_BITS-1:0] nco_out
);
    reg [NCO_BITS-1:0] nco_cnt;

    always @ (posedge clk_in or posedge rst_in) begin
        if (rst_in) begin
            nco_cnt <= {NCO_BITS{1'b0}};
        end else begin
            nco_cnt <= nco_cnt + fcw_in; // Increment NCO output by frequency control word
        end
    end

    assign nco_out = nco_cnt;

endmodule