module spi_slave #(
    parameter DATA_WIDTH = 12
) (
    // input wire mosi,
    output reg miso_slave,
    input wire sck,
    input wire ssel_slave,
    input wire [DATA_WIDTH-1:0]tx_data
);
    reg [DATA_WIDTH-1:0]d_reg;

    always @(posedge sck) begin
        if (~ ssel_slave) begin
            miso_slave <= d_reg[DATA_WIDTH-1];
            d_reg <= {d_reg[DATA_WIDTH-2:0], 1'b0};
        end
        else begin
            d_reg <= tx_data;
        end
    end
endmodule