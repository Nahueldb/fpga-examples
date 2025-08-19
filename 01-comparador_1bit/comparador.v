module comparador (
    input wire a_in,
    input wire b_in,
    output wire gt_out,
    output wire lt_out,
    output wire eq_out
);

    assign eq_out = ~(a_in ^ b_in);  // eq = 1 cuando a y b son iguales
    assign gt_out = a_in && ~b_in;
    assign lt_out = ~a_in && b_in;

endmodule
