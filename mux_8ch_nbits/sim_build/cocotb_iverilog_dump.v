module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/mux8chNbits.fst");
    $dumpvars(0, mux8chNbits);
end
endmodule
