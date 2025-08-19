module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/pipo.fst");
    $dumpvars(0, pipo);
end
endmodule
