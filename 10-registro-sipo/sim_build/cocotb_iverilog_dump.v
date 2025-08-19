module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/sipo.fst");
    $dumpvars(0, sipo);
end
endmodule
