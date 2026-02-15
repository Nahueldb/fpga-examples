module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/spi.fst");
    $dumpvars(0, spi);
end
endmodule
