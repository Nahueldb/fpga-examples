module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/piso.fst");
    $dumpvars(0, piso);
end
endmodule
