module spi_master #(
    parameter DATA_WIDTH = 12
) (
    input wire clk,
    // output wire mosi,
    input wire miso,
    input wire ssel_in,
    output wire sck,
    output wire ssel,
    output reg [DATA_WIDTH-1:0]d_reg_master,
    output reg sample_valid
);
    reg [DATA_WIDTH-1:0] bit_cnt;
    assign sck = clk;
    assign ssel = ssel_in;

    always @(posedge sck) begin
        if (ssel == 0) begin
            d_reg_master <= {d_reg_master[DATA_WIDTH-2:0], miso};
            bit_cnt <= bit_cnt + 1;
            if (bit_cnt == DATA_WIDTH-1) begin
                sample_valid <= 1'b1; // Indica que se ha recibido una muestra completa
                bit_cnt <= 0; // Reinicia el contador de bits
            end else begin
                sample_valid <= 1'b0; // No hay muestra válida aún
            end
        end
    end
endmodule