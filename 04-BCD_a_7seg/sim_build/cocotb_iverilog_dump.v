module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/bcd7seg.fst");
    $dumpvars(0, bcd7seg);
end
endmodule
