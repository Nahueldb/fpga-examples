# Comparador N-bits

- [Comparador N-bits](#comparador-n-bits)
  - [Descripcion](#descripcion)
    - [Tabla de verdad](#tabla-de-verdad)
  - [Código](#código)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)
    - [Testbench en Python (Cocotb)](#testbench-en-python-cocotb)

## Descripcion

Un comparador de N bitS es un circuito lógico que compara dos números binarios de N bits y determina su relación. El comparador produce tres salidas:

- `gt` (greater than): Indica si el primer número es mayor que el segundo.
- `lt` (less than): Indica si el primer número es menor que el segundo.
- `eq` (equal): Indica si ambos números son iguales.

### Tabla de verdad

| A (N bits) | B (N bits) | gt | lt | eq |
|------------|------------|----|----|----|
| 00         | 00         | 0  | 0  | 1  |
| 00         | 01         | 0  | 1  | 0  |
| 00         | 10         | 0  | 1  | 0  |
| 00         | 11         | 0  | 1  | 0  |
| 01         | 00         | 1  | 0  | 0  |
| 01         | 01         | 0  | 0  | 1  |
| 01         | 10         | 0  | 1  | 0  |
| 01         | 11         | 0  | 1  | 0  |
| 10         | 00         | 1  | 0  | 0  |
| 10         | 01         | 1  | 0  | 0  |
| 10         | 10         | 0  | 0  | 1  |
| 10         | 11         | 0  | 1  | 0  |
| 11         | 00         | 1  | 0  | 0  |
| 11         | 01         | 1  | 0  | 0  |
| 11         | 10         | 1  | 0  | 0  |
| 11         | 11         | 0  | 0  | 1  |

## Código

### Verilog

```verilog
module comparador_nbits #(
    parameter N = 2
    )(
    input wire [N-1:0] a_in,
    input wire [N-1:0] b_in,
    output reg gt_out,
    output reg lt_out,
    output reg eq_out
);

    always @(*) begin
        if (a_in > b_in) begin
            gt_out = 1;
            lt_out = 0;
            eq_out = 0;
        end else if (a_in < b_in) begin
            gt_out = 0;
            lt_out = 1;
            eq_out = 0;
        end else begin
            gt_out = 0;
            lt_out = 0;
            eq_out = 1;
        end
    end


endmodule

```

## Simulacion

### Testbench en verilog

```verilog
`include "comparador_nbits.v"
`timescale 1ns / 1ps

module tb_comparador_nbits;

    // Declaración de señales
    reg [1:0] a_in ; // Cambiar el tamaño según N
    reg [1:0] b_in; // Cambiar el tamaño según N
    wire gt_out;
    wire lt_out;
    wire eq_out;

    // Instanciamos el DUT (Device Under Test)
    comparador_nbits dut (
        .a_in(a_in),
        .b_in(b_in),
        .gt_out(gt_out),
        .lt_out(lt_out),
        .eq_out(eq_out)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("comparador_nbits.vcd");
        $dumpvars(0, tb_comparador_nbits);
    end

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        a_in = 2'b00;
        b_in = 2'b00;
        #10;
        a_in = 2'b01; // a_in < b_in
        b_in = 2'b10;
        #10;
        a_in = 2'b10; // a_in > b_in
        b_in = 2'b01;
        #10;
        a_in = 2'b11; // a_in == b_in
        b_in = 2'b11;
        #10;
    end

endmodule
```

### Testbench en Python (Cocotb)

```python
import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def comparador_nbits_tb(dut):
    """Testbench for the COMPARADOR N BITS."""


    # Test all combinations of inputs
    for a in range(4):
        for b in range(4):
            dut.a_in.value = a
            dut.b_in.value = b
            await Timer(1, units='ns')
            if a > b:
                assert dut.gt_out.value.integer == 1, f"gt should be 1 for a={a}, b={b}"
                assert dut.lt_out.value.integer == 0, f"lt should be 0 for a={a}, b={b}"
                assert dut.eq_out.value.integer == 0, f"eq should be 0 for a={a}, b={b}"
            elif a < b:
                assert dut.gt_out.value.integer == 0, f"gt should be 0 for a={a}, b={b}"
                assert dut.lt_out.value.integer == 1, f"lt should be 1 for a={a}, b={b}"
                assert dut.eq_out.value.integer == 0, f"eq should be 0 for a={a}, b={b}"
            else:
                assert dut.gt_out.value.integer == 0, f"gt should be 0 for a={a}, b={b}"
                assert dut.lt_out.value.integer == 0, f"lt should be 0 for a={a}, b={b}"
                assert dut.eq_out.value.integer == 1, f"eq should be 1 for a={a}, b={b}"
```
