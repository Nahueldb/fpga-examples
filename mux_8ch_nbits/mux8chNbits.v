module mux8chNbits #(
    parameter N = 4 // Number of bits per channel
    )(
    input wire [2:0] sel_in,
    input wire [N-1:0] data_in_0,
    input wire [N-1:0] data_in_1,
    input wire [N-1:0] data_in_2,
    input wire [N-1:0] data_in_3,
    input wire [N-1:0] data_in_4,
    input wire [N-1:0] data_in_5,
    input wire [N-1:0] data_in_6,
    input wire [N-1:0] data_in_7,
    output reg [N-1:0] data_out
);
    always @(*) begin
        case (sel_in)
            3'b000: data_out = data_in_0;
            3'b001: data_out = data_in_1;
            3'b010: data_out = data_in_2;
            3'b011: data_out = data_in_3;
            3'b100: data_out = data_in_4;
            3'b101: data_out = data_in_5;
            3'b110: data_out = data_in_6;
            3'b111: data_out = data_in_7;
            default: data_out = {N{1'b0}}; // Default case to avoid latches
        endcase
    end
endmodule

