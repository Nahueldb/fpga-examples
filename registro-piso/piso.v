module piso #(
    parameter DATA_WIDTH = 4,
    parameter CLOCK_EDGE = 1 // 1 para flanco ascendente, 0 para descendente
)(
    input wire [DATA_WIDTH-1:0] d_in,
    output wire q_out,
    input wire out_enable_in,
    input wire rst,
    input wire clk,
    input wire clk_enable,
    input wire load_enable_in
);
    reg [DATA_WIDTH-1:0] d_reg;
    generate
        if (CLOCK_EDGE == 1) begin : posedge_clk
            always @ (posedge clk or posedge rst)
                begin
                    if (rst) begin
                        d_reg <= {DATA_WIDTH{1'b0}};
                    end else if (load_enable_in) begin
                        d_reg <= d_in;
                    end else if (clk_enable) begin
                        d_reg <= {d_reg[DATA_WIDTH-2:0], 1'b0};
                    end
                end
        end else begin : negedge_clk
            always @ (negedge clk or posedge rst)
                begin
                    if (rst) begin
                        d_reg <= {DATA_WIDTH{1'b0}};
                    end else if (load_enable_in) begin
                        d_reg <= d_in;
                    end else if (clk_enable) begin
                        d_reg <= {d_reg[DATA_WIDTH-2:0], 1'b0};
                    end
                end
        end
    endgenerate

    assign q_out = out_enable_in ? d_reg[DATA_WIDTH-1] : 1'bz;

endmodule