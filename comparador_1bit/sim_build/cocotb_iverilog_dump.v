module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/comparador.fst");
    $dumpvars(0, comparador);
end
endmodule
