# BCD a 7-segmentos

- [BCD a 7-segmentos](#bcd-a-7-segmentos)
  - [Descripcion](#descripcion)
    - [Tabla de verdad](#tabla-de-verdad)
  - [Codigo](#codigo)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)

## Descripcion

El circuito BCD a 7-segmentos convierte un número en formato BCD a una representación que puede ser mostrada en un display de 7 segmentos. Cada combinación de 4 bits de entrada (representando un dígito del 0 al F) activa ciertos segmentos del display para mostrar el dígito correspondiente.

### Tabla de verdad

| Entrada A | Entrada B | Entrada C | Entrada D | Segmentos (a-g) |
|-----------|-----------|-----------|-----------|-----------------|
|     0     |     0     |     0     |     0     |  1111110        |
|     0     |     0     |     0     |     1     |  0110000        |
|     0     |     0     |     1     |     0     |  1101101        |
|     0     |     0     |     1     |     1     |  1111001        |
|     0     |     1     |     0     |     0     |  0110011        |
|     0     |     1     |     0     |     1     |  1011011        |
|     0     |     1     |     1     |     0     |  1011111        |
|     0     |     1     |     1     |     1     |  1110000        |
|     1     |     0     |     0     |     0     |  1111111        |
|     1     |     0     |     0     |     1     |  1111011        |
|     1     |     0     |     1     |     0     |  1110111        |
|     1     |     0     |     1     |     1     |  0011111        |
|     1     |     1     |     0     |     0     |  1001110        |
|     1     |     1     |     0     |     1     |  0111101        |
|     1     |     1     |     1     |     0     |  1001111        |
|     1     |     1     |     1     |     1     |  1000111        |

## Codigo

### Verilog

```verilog
module bcd7seg (
    input wire [3:0] bcd_in,
    output reg [6:0] sseg_out,
    output wire [3:0] digit_enable
);
    parameter common_anode = 1;

    assign digit_enable = 4'b0111; // habilitás solo el primer dígito

    always @(*) begin
        case (bcd_in)
            4'b0000: sseg_out = 7'b1111110;
            4'b0001: sseg_out = 7'b0110000;
            4'b0010: sseg_out = 7'b1101101;
            4'b0011: sseg_out = 7'b1111001;
            4'b0100: sseg_out = 7'b0110011;
            4'b0101: sseg_out = 7'b1011011;
            4'b0110: sseg_out = 7'b1011111;
            4'b0111: sseg_out = 7'b1110000;
            4'b1000: sseg_out = 7'b1111111;
            4'b1001: sseg_out = 7'b1111011;
            4'b1010: sseg_out = 7'b1110111; // A
            4'b1011: sseg_out = 7'b0011111; // B
            4'b1100: sseg_out = 7'b1001110; // C
            4'b1101: sseg_out = 7'b0111101; // D
            4'b1110: sseg_out = 7'b1001111; // E
            4'b1111: sseg_out = 7'b1000111; // F
            // Casos no válidos, todos los segmentos apagados
            default: sseg_out = 7'b0000000;
        endcase

        if (common_anode) begin
            sseg_out = ~sseg_out;
        end
    end
endmodule
```

## Simulacion

### Testbench en verilog

```verilog
`include "bcd7seg.v"
`timescale 1ns / 1ps

module tb_bcd7seg;

    // Declaración de señales
    reg [3:0] bcd_in; // Entrada BCD de 4 bits
    wire [7:0] sseg_out; // Salida para los segmentos del display de 7 segmentos
    wire [3:0] digit_enable; // Salida para habilitar los dígitos (opcional)


    // Instanciamos el DUT (Device Under Test)
    bcd7seg dut (
        .bcd_in(bcd_in),
        .sseg_out(sseg_out),
        .digit_enable(digit_enable)
    );

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("bcd7seg.vcd");
        $dumpvars(0, tb_bcd7seg
    );
    end

    // Generación de señales de prueba
    initial begin
        // Inicializamos las señales
        bcd_in = 4'b0000; // Comenzamos con 0
        #100 bcd_in = 4'b0001; // Caso 1
        #100 bcd_in = 4'b0010; // Caso 2
        #100 bcd_in = 4'b0011; // Caso 3
        #100 bcd_in = 4'b0100; // Caso 4
        #100 bcd_in = 4'b0101; // Caso 5
        #100 bcd_in = 4'b0110; // Caso 6
        #100 bcd_in = 4'b0111; // Caso 7
        #100 bcd_in = 4'b1000; // Caso 8
        #100 bcd_in = 4'b1001; // Caso 9
        #100 bcd_in = 4'b1010; // Caso no válido, todos los segmentos apagados
        #100 bcd_in = 4'b1111; // Caso no válido, todos los segmentos apagados
        #100 bcd_in = 4'b0000; // Volvemos a 0

        // Finalizamos la simulación
        #100 $finish;
    end

endmodule
```
