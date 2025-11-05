`include "spi_master.v"
`include "spi_slave.v"


module spi (
    input wire clk,
    input wire rst,
    // output wire mosi,
    input wire ssel_in,
    output wire [11:0] d_reg_master
    // output wire [11:0] test_wire
);
    wire sck;
    wire ssel;
    parameter DATA_WIDTH = 12;
    wire miso;

    spi_master #(
        .DATA_WIDTH(DATA_WIDTH)
    ) master_inst (
        .clk(clk),
        // .mosi(mosi),
        .miso(miso),
        .ssel_in(ssel_in),
        .sck(sck),
        .ssel(ssel),
        .d_reg_master(d_reg_master)
    );

    spi_slave #(
        .DATA_WIDTH(DATA_WIDTH)
    ) slave_inst (
        // .mosi(mosi),
        .miso_slave(miso),
        .sck(sck),
        .ssel_slave(ssel)
        // .test_wire(test_wire)
    );

    initial begin
        $dumpfile("spi_wave.vcd");
        $dumpvars(0, spi);
    end

endmodule