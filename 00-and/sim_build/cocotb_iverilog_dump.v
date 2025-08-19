module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/and_2.fst");
    $dumpvars(0, and_2);
end
endmodule
