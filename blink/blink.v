module blink_led (
    input wire clk,
    output reg led = 0  // ✅ Inicializado a 0
);

    parameter COUNT_MAX = 1_000_000;

    reg [24:0] counter = 0;

    always @(posedge clk) begin
        if (counter == COUNT_MAX - 1) begin
            counter <= 0;
            led <= ~led;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule
