module and_2 (
    input wire a_in,
    input wire b_in,
    output wire q_out
);

    assign q_out = a_in && b_in;

endmodule
