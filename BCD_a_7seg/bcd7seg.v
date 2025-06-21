module bcd7seg (
    input wire [3:0] bcd_in,
    output reg [6:0] sseg_out,
    output wire [3:0] digit_enable
);
    parameter common_anode = 1;

    assign digit_enable = 4'b0111; // habilitás solo el primer dígito

    always @(*) begin
        case (bcd_in)
            4'b0000: sseg_out = 7'b1111110;
            4'b0001: sseg_out = 7'b0110000;
            4'b0010: sseg_out = 7'b1101101;
            4'b0011: sseg_out = 7'b1111001;
            4'b0100: sseg_out = 7'b0110011;
            4'b0101: sseg_out = 7'b1011011;
            4'b0110: sseg_out = 7'b1011111;
            4'b0111: sseg_out = 7'b1110000;
            4'b1000: sseg_out = 7'b1111111;
            4'b1001: sseg_out = 7'b1111011;
            // completar a b c d e f
            4'b1010: sseg_out = 7'b1110111; // A
            4'b1011: sseg_out = 7'b0011111; // B
            4'b1100: sseg_out = 7'b1001110; // C
            4'b1101: sseg_out = 7'b0111101; // D
            4'b1110: sseg_out = 7'b1001111; // E
            4'b1111: sseg_out = 7'b1000111; // F
            // Casos no válidos, todos los segmentos apagados
            default: sseg_out = 7'b0000000;
        endcase

        if (common_anode) begin
            sseg_out = ~sseg_out;
        end
    end
endmodule
