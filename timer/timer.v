module timer #(
    parameter CLK_FREQ = 12_000_000,
    parameter TIMER_SET = 180
) (
    input wire clk,
    input wire signal_in,
    output reg led_red = 0,
    output reg led_green = 0,
    output reg led_yellow = 0,
    output reg signal_out = 0
);
    parameter COUNT_MAX = TIMER_SET * CLK_FREQ;
    reg [22:0] counter = 0;

    typedef enum reg [1:0] {
        IDLE,
        GREEN,
        YELLOW,
        RED
    } state_t;

    state_t state = IDLE;


    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (signal_in) begin
                    state <= GREEN;
                    counter <= 0;
                    led_green <= 1;
                end
            end
            GREEN: begin
                if (counter == COUNT_MAX - 1) begin
                    state <= YELLOW;
                    counter <= 0;
                    led_yellow <= 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            YELLOW: begin
                if (counter == COUNT_MAX - 1) begin
                    state <= RED;
                    counter <= 0;
                    led_red <= 1;
                end else begin
                    counter <= counter + 1;
                end
            end
            RED: begin
                if (counter == COUNT_MAX - 1) begin
                    state <= IDLE;
                    counter <= 0;
                    signal_out <= 1;
                end else begin
                    counter <= counter + 1;
                end
            end
        endcase
    end

    initial begin
        $dumpfile("timer_wave.vcd");
        $dumpvars(0, timer);
    end

endmodule