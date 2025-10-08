module spi_master #(
    parameter DATA_WIDTH = 8
) (
    input wire clk,
    output wire mosi,
    input wire miso,
    output wire sck,
    output wire ssel
);
    reg [DATA_WIDTH-1:0]d_reg;
    assign sck = clk;
    assign ssel = 1'b0; // Active low, always selected for simplicity

    always @(posedge sck) begin
        d_reg >= {d_reg[DATA_WIDTH-2:0], miso};
    end
endmodule