module spi_slave #(
    parameter DATA_WIDTH = 12
) (
    // input wire mosi,
    output reg miso_slave,
    input wire sck,
    input wire ssel_slave,
    output reg [DATA_WIDTH-1:0] test_wire
);
    parameter COUNT_MAX = 12;
    reg [DATA_WIDTH-1:0] d_reg;
    reg [DATA_WIDTH-1:0] LUT [0:1023]; // 1024 valores de 12 bits
    reg [9:0] counter_address = 0;
    reg [4:0] counter_clock = 0;
    reg flag_address;

    initial begin
        $readmemh("sine_table.hex", LUT);
    end

    always @(posedge sck) begin

        if (ssel_slave) begin
            d_reg <= LUT[counter_address];
            counter_clock <= 0;
            flag_address <= 1'b1;
        end
        else begin
            if (counter_clock == COUNT_MAX - 1 && flag_address) begin
                flag_address <= 1'b0;
                counter_address <= counter_address + 1;
                // d_reg <= LUT[counter_address];
                // counter_clock <= 0;
            end
            else begin
                counter_clock <= counter_clock + 1;
                miso_slave <= d_reg[DATA_WIDTH-1];
                test_wire <= d_reg; // For testing purposes
                d_reg <= {d_reg[DATA_WIDTH-2:0], 1'b0};
            end
        end
    end
endmodule