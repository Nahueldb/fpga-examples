module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/contador_display.fst");
    $dumpvars(0, contador_display);
end
endmodule
