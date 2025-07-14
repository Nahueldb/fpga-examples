module comparador_nbits #(
    parameter N = 2
    )(
    input wire [N-1:0] a_in,
    input wire [N-1:0] b_in,
    output reg gt_out,
    output reg lt_out,
    output reg eq_out
);

    always @(*) begin
        if (a_in > b_in) begin
            gt_out = 1;
            lt_out = 0;
            eq_out = 0;
        end else if (a_in < b_in) begin
            gt_out = 0;
            lt_out = 1;
            eq_out = 0;
        end else begin
            gt_out = 0;
            lt_out = 0;
            eq_out = 1;
        end
    end


endmodule
