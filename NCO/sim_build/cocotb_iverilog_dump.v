module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/nco.fst");
    $dumpvars(0, nco);
end
endmodule
