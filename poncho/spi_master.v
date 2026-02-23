module spi_master #(
    parameter DATA_WIDTH = 12
) (
    input wire clk,
    // output wire mosi,
    input wire miso,
    input wire rst,
    input wire fifo_full,
    input wire sample_tick,
    output wire sck,
    output reg ssel,
    output reg [DATA_WIDTH-1:0]d_reg_master,
    output reg sample_valid
);
    reg [$clog2(DATA_WIDTH)-1:0] bit_cnt;
    assign sck = clk;

    always @(posedge sck) begin
        if (rst) begin
            ssel <= 1'b1; // Inactiva el slave al reset
            d_reg_master <= {DATA_WIDTH{1'b0}}; // Limpia el registro de datos
            sample_valid <= 1'b0; // Reinicia la señal de muestra válida
            bit_cnt <= 0; // Reinicia el contador de bits
        end else begin
            sample_valid <= 1'b0; // Reinicia la señal de muestra válida en cada ciclo
            if (ssel == 0) begin
                d_reg_master <= {d_reg_master[DATA_WIDTH-2:0], miso};
                bit_cnt <= bit_cnt + 1;
                if (bit_cnt == DATA_WIDTH-1) begin
                    sample_valid <= 1'b1; // Indica que se ha recibido una muestra completa
                    bit_cnt <= 0; // Reinicia el contador de bits
                    ssel <= 1'b1; // Desactiva el slave después de recibir los datos
                end
            end else if (ssel == 1 && fifo_full == 0 && sample_tick == 1) begin
                ssel <= 1'b0; // Activa el slave cuando el FIFO no está lleno
                sample_valid <= 1'b0; // Reinicia la señal de muestra válida
            end
        end
    end
endmodule