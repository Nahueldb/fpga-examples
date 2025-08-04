module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/siso.fst");
    $dumpvars(0, siso);
end
endmodule
