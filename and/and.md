
# Compuerta AND de 2 entradas

- [Compuerta AND de 2 entradas](#compuerta-and-de-2-entradas)
  - [Descripcion](#descripcion)
    - [Tabla de verdad](#tabla-de-verdad)
  - [Codigo](#codigo)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)

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
    input wire a,
    input wire b,
    output wire q
);
    // Compuerta AND de 2 entradas
    // La salida q es alta solo si ambas entradas a y b son altas
    assign q = a && b;

endmodule
```

## Simulacion

### Testbench en verilog

```verilog
`include "and.v"
`timescale 1ns / 1ps

module tb_and;

    // Declaración de señales
    reg a;
    reg b;
    wire q;

    // Instanciamos el DUT (Device Under Test)
    and_2 dut (
        .a(a),
        .b(b),
        .q(q)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("and.vcd");
        $dumpvars(0, tb_and);
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
