module lut #(
    parameter ADDR_BITS = 10,
    parameter DATA_OUT_BITS = 12
)(
    input wire [ADDR_BITS-1:0] addr_in,
    output reg [DATA_OUT_BITS-1:0] data_out,
    input wire clk_in // Added clock input
);
    reg [DATA_OUT_BITS-1:0] LUT [0:262094]; // 1024 valores de 12 bits

    initial begin
        $readmemh("audio_full.hex", LUT);
    end

    // assign data_out = LUT[addr_in];

    always @(posedge clk_in) begin
        data_out <= LUT[addr_in];
    end

endmodule