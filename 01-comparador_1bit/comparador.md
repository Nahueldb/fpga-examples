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

```

## Simulacion

### Testbench en verilog

```verilog
`include "comparador.v"
`timescale 1ns / 1ps

module tb_comparador;

    // Declaración de señales
    reg a;
    reg b;
    wire eq;
    wire gt;
    wire lt;

    // Instanciamos el DUT (Device Under Test)
    comparador dut (
        .a(a),
        .b(b),
        .eq(eq),
        .gt(gt),
        .lt(lt)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("comparador.vcd");
        $dumpvars(0, tb_comparador);
    end

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        a = 0; b = 0;

        // Cambios en las señales para probar el circuito
        #100 a = 1; b = 0; // Caso 1
        #100 a = 0; b = 1; // Caso 2
        #100 a = 1; b = 1; // Caso 3
        #100 a = 0; b = 0; // Caso 4

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
    
    dut.a.value = 0
    dut.b.value = 0
    await Timer(1, units='ns')
    assert dut.gt.value.integer == 0, "Initial gt value should be 0"
    assert dut.lt.value.integer == 0, "Initial lt value should be 0"
    assert dut.eq.value.integer == 1, "Initial eq value should be 1"

    dut.a.value = 1
    dut.b.value = 0

    await Timer(1, units='ns')
    assert dut.gt.value.integer == 1, "gt should be 1 when a > b"
    assert dut.lt.value.integer == 0, "lt should be 0 when a > b"
    assert dut.eq.value.integer == 0, "eq should be 0 when a > b"

    dut.a.value = 0
    dut.b.value = 1
    await Timer(1, units='ns')
    assert dut.gt.value.integer == 0, "gt should be 0 when a < b"
    assert dut.lt.value.integer == 1, "lt should be 1 when a < b"
    assert dut.eq.value.integer == 0, "eq should be 0 when a < b"

    dut.a.value = 1
    dut.b.value = 1
    await Timer(1, units='ns')
    assert dut.gt.value.integer == 0, "gt should be 0 when a == b"
    assert dut.lt.value.integer == 0, "lt should be 0 when a == b"
    assert dut.eq.value.integer == 1, "eq should be 1 when a == b"
```
