
# Compuerta AND de 2 entradas

- [Compuerta AND de 2 entradas](#compuerta-and-de-2-entradas)
  - [Descripcion](#descripcion)
    - [Tabla de verdad](#tabla-de-verdad)
  - [Codigo](#codigo)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)
    - [Testbench en Python (Cocotb)](#testbench-en-python-cocotb)

## Descripcion

La compuerta AND de 2 entradas es un circuito lógico que produce una salida alta (1) solo cuando ambas entradas son altas (1). En cualquier otro caso, la salida es baja (0).

### Tabla de verdad

| Entrada A | Entrada B | Salida Q |
|-----------|-----------|----------|
|     0     |     0     |    0     |
|     0     |     1     |    0     |
|     1     |     0     |    0     |
|     1     |     1     |    1     |

## Codigo

### Verilog

```verilog
module and_2 (
    input wire a_in,
    input wire b_in,
    output wire q_out
);

    assign q_out = a_in && b_in;

endmodule
```

## Simulacion

### Testbench en verilog

```verilog
`include "and.v"
`timescale 1ns / 1ps

module tb_and;

    // Declaración de señales
    reg a_in;
    reg b_in;
    wire q_out;

    // Instanciamos el DUT (Device Under Test)
    and_2 dut (
        .a_in(a_in),
        .b_in(b_in),
        .q_out(q_out)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("and.vcd");
        $dumpvars(0, tb_and);
    end

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        a_in = 0; b_in = 0;

        // Cambios en las señales para probar el circuito
        #100 a_in = 1; b_in = 0; // Caso 1
        #100 a_in = 0; b_in = 1; // Caso 2
        #100 a_in = 1; b_in = 1; // Caso 3
        #100 a_in = 0; b_in = 0; // Caso 4

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
async def and_tb(dut):
    """Testbench for the AND gate."""
    # A = 0, B = 0, Output = 0
    dut.a_in.value = 0
    dut.b_in.value = 0
    await Timer(1, units='ns')
    assert dut.q_out.value == 0

    # A = 0, B = 1, Output = 0
    dut.a_in.value = 0
    dut.b_in.value = 1
    await Timer(1, units='ns')
    assert dut.q_out.value == 0

    # A = 1, B = 0, Output = 0
    dut.a_in.value = 1
    dut.b_in.value = 0
    await Timer(1, units='ns')
    assert dut.q_out.value == 0

    # A = 1, B = 1, Output = 1
    dut.a_in.value = 1
    dut.b_in.value = 1
    await Timer(1, units='ns')
    assert dut.q_out.value == 1
```
