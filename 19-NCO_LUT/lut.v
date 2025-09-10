module lut #(
    parameter ADDR_BITS = 10
)(
    input wire [ADDR_BITS-1:0] addr_in,
    output reg [11:0] data_out
);
    reg [11:0] LUT [0:1023]; // 1024 valores de 12 bits

    initial begin
        $readmemh("sine_table.hex", LUT);
    end

    assign data_out = LUT[addr_in];

endmodule