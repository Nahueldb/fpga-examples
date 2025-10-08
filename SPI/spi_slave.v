module spi_slave #(
    parameter DATA_WIDTH = 8
) (
    input wire mosi,
    output wire miso,
    input wire sck,
    input wire ssel
);
    reg [DATA_WIDTH-1:0]d_reg;

    always @(posedge sck) begin
        if (~ ssel) begin
            d_reg >= {d_reg[DATA_WIDTH-2:0], mosi};
        end
    end
endmodule