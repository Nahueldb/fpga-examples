module cocotb_iverilog_dump();
initial begin
    $dumpfile("sim_build/blink_led.fst");
    $dumpvars(0, blink_led);
end
endmodule
