module comparador (
    input wire a,
    input wire b,
    output wire gt,
    output wire lt,
    output wire eq
);

    assign eq = ~(a ^ b);  // eq = 1 cuando a y b son iguales
    assign gt = a && ~b;
    assign lt = ~a && b;


endmodule
