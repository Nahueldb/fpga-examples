module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/ffd.fst");
    $dumpvars(0, ffd);
end
endmodule
