# Comparador 1-bit

- [Comparador 1-bit](#comparador-1-bit)
  - [Descripcion](#descripcion)
    - [Tabla de verdad](#tabla-de-verdad)
  - [Codigo](#codigo)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)
    - [Testbench en Python (Cocotb)](#testbench-en-python-cocotb)

## Descripcion

Un comparador de 1 bit es un circuito lógico que compara dos bits de entrada y produce tres salidas: una para indicar si el primer bit es mayor que el segundo (gt), otra para indicar si el primer bit es menor que el segundo (lt) y una tercera para indicar si ambos bits son iguales (eq).

### Tabla de verdad

| Entrada A | Entrada B | gt | lt | eq |
|-----------|-----------|----|----|----|
|     0     |     0     |  0 |  0 |  1 |
|     0     |     1     |  0 |  1 |  0 |
|     1     |     0     |  1 |  0 |  0 |
|     1     |     1     |  0 |  0 |  1 |

## Codigo

### Verilog

```verilog
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
```

## Simulacion

### Testbench en verilog

```verilog
`include "comparador.v"
`timescale 1ns / 1ps

module tb_comparador;

    // Declaración de señales
    reg a_in;
    reg b_in;
    wire eq_out;
    wire gt_out;
    wire lt_out;

    // Instanciamos el DUT (Device Under Test)
    comparador dut (
        .a_in(a_in),
        .b_in(b_in),
        .eq_out(eq_out),
        .gt_out(gt_out),
        .lt_out(lt_out)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("comparador.vcd");
        $dumpvars(0, tb_comparador);
    end

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        a_in = 0; b_in = 0;

        // Cambios en las señales para probar el circuito
        #100 a_in = 1; b_in = 0;
        #100 a_in = 0; b_in = 1;
        #100 a_in = 1; b_in = 1;
        #100 a_in = 0; b_in = 0;

        // Finalizamos la simulación
        #100 $finish;
    end

endmodule
```

### Testbench en Python (Cocotb)

```python
import cocotb
from cocotb.triggers import Timer


@cocotb.test()
async def comparador_tb(dut):
    """Testbench for the COMPARADOR."""

    dut.a_in.value = 0
    dut.b_in.value = 0
    await Timer(1, units='ns')
    assert dut.gt_out.value.integer == 0, "Initial gt value should be 0"
    assert dut.lt_out.value.integer == 0, "Initial lt value should be 0"
    assert dut.eq_out.value.integer == 1, "Initial eq value should be 1"

    dut.a_in.value = 1
    dut.b_in.value = 0

    await Timer(1, units='ns')
    assert dut.gt_out.value.integer == 1, "gt should be 1 when a > b"
    assert dut.lt_out.value.integer == 0, "lt should be 0 when a > b"
    assert dut.eq_out.value.integer == 0, "eq should be 0 when a > b"

    dut.a_in.value = 0
    dut.b_in.value = 1
    await Timer(1, units='ns')
    assert dut.gt_out.value.integer == 0, "gt should be 0 when a < b"
    assert dut.lt_out.value.integer == 1, "lt should be 1 when a < b"
    assert dut.eq_out.value.integer == 0, "eq should be 0 when a < b"

    dut.a_in.value = 1
    dut.b_in.value = 1
    await Timer(1, units='ns')
    assert dut.gt_out.value.integer == 0, "gt should be 0 when a == b"
    assert dut.lt_out.value.integer == 0, "lt should be 0 when a == b"
    assert dut.eq_out.value.integer == 1, "eq should be 1 when a == b"
```
