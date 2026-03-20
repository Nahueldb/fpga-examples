`include "pwm.v"
`include "spi_master.v"
`include "fifo.v"

module top (
    input wire clk_in,
    input wire rst_in,
    output wire [11:0] d_reg_master,
    input wire miso,
    output wire pwm_out,
    output wire ssel_out,
    output wire [$clog2(DATA_OUT_BITS)-1:0] bit_cnt
    );
    // Parámetros
    parameter DATA_OUT_BITS = 12;
    parameter PWM_BITS = 12;

    // Salidas intermedias
    wire [DATA_OUT_BITS-1:0] data_out;
    wire sck;
    wire sample_valid;
    wire pwm_period_done;
    wire fifo_full;
    wire fifo_empty;
    wire fifo_rd_en;

    reg [7:0] sample_cnt;
    reg sample_tick;

    always @(posedge clk_in) begin
        if (rst_in) begin
            sample_cnt  <= 0;
            sample_tick <= 0;
        end else begin
            if (sample_cnt == 499) begin
                sample_cnt  <= 0;
                sample_tick <= 1;   // pulso de 1 ciclo
            end else begin
                sample_cnt  <= sample_cnt + 1;
                sample_tick <= 0;
            end
        end
    end

    // Instancia del SPI Master
    spi_master #(
        .DATA_WIDTH(DATA_OUT_BITS)
    ) master_inst (
        .clk(clk_in),
        // .mosi(mosi),
        .miso(miso),
        .rst(rst_in),
        .fifo_full(fifo_full),
        .sample_tick(sample_tick),
        .sck(sck),
        .ssel(ssel_out),
        .d_reg_master(d_reg_master),
        .sample_valid(sample_valid),
        .bit_cnt(bit_cnt)
    );

    // Instancia de la FIFO
    fifo #(
        .DATA_WIDTH(DATA_OUT_BITS),
        .FIFO_DEPTH(16) // Profundidad de la FIFO
    ) fifo_inst (
        .clk(clk_in),
        .rst(rst_in),
        .wr_en(sample_valid), // Escribimos en la FIFO cuando hay una muestra válida
        .rd_en(fifo_rd_en), // Leemos de la FIFO al finalizar un período del PWM
        .data_in(d_reg_master),
        .data_out(data_out),
        .full(fifo_full),
        .empty(fifo_empty)
    );

    // Instancia del PWM
    pwm #(
        .PWM_BITS(PWM_BITS)
    ) pwm_inst (
        .rst_in(rst_in),
        .clk_pwm(clk_in),
        .pwm_in(data_out), // El valor del PWM viene de la salida de la FIFO
        .pwm_out(pwm_out),
        .pwm_period_done(pwm_period_done)
    );

    assign fifo_rd_en = pwm_period_done && !fifo_empty;

    initial begin
        $dumpfile("top_wave.vcd");
        $dumpvars(0, top);
    end

    initial begin
        $dumpfile("top_wave.vcd");
        $dumpvars(0, top);
    end

endmodule
