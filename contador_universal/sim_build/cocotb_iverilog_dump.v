module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/contador_universal.fst");
    $dumpvars(0, contador_universal);
end
endmodule
