`include "nco.v"
`timescale 1ns / 1ps


module nco_tb #(
    parameter NCO_BITS = 4,
    parameter NCO_FREQ_BITS = 4 // Number of bits for frequency control word
);

    reg clk_in = 0;
    reg rst_in;
    reg [NCO_FREQ_BITS-1:0] fcw_in;
    wire [NCO_BITS-1:0] nco_out;

    nco dut (
        .clk_in(clk_in),
        .rst_in(rst_in),
        .fcw_in(fcw_in),
        .nco_out(nco_out)
    );

    initial begin
        $dumpfile("nco.vcd");
        $dumpvars(0, nco_tb);
    end

    always #10 clk_in = ~clk_in;
    initial begin
        // Initialize signals
        rst_in = 1;
        fcw_in = {NCO_FREQ_BITS{1'b0}};

        #20 rst_in = 0; // Release reset

        #20 fcw_in = 4'b0001; // Set frequency control word

        #300 fcw_in = 4'b0010; // Change frequency control word

        #200 fcw_in = 4'b0100; // Change frequency control word again

        #100 $finish; // End simulation
    end
endmodule