module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/comparador_nbits.fst");
    $dumpvars(0, comparador_nbits);
end
endmodule
