module spi_master #(
    parameter DATA_WIDTH = 12
) (
    input wire clk,
    // output wire mosi,
    input wire miso,
    input wire ssel_in,
    output wire sck,
    output wire ssel,
    output reg [DATA_WIDTH-1:0]d_reg_master
);
    assign sck = clk;
    assign ssel = ssel_in;

    always @(posedge sck) begin
        if (ssel == 0) begin
            d_reg_master <= {d_reg_master[DATA_WIDTH-2:0], miso};
        end
    end
endmodule