# Registro SIPO

- [Registro SIPO](#registro-sipo)
  - [Descripcion](#descripcion)
    - [Tabla de verdad](#tabla-de-verdad)
  - [Codigo](#codigo)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)
    - [Testbench en Python (Cocotb)](#testbench-en-python-cocotb)

## Descripcion

El Registro SIPO (Serial In Parallel Out) es un tipo de registro que permite la entrada de datos en serie y la salida en paralelo.


## Codigo

### Verilog

```verilog
module sipo #(
    parameter DATA_WIDTH = 4,
    parameter CLOCK_EDGE = 1 // 1 para flanco ascendente, 0 para descendente
)(
    input wire d_in,
    output wire [DATA_WIDTH-1:0] q_out,
    input wire out_enable_in,
    input wire rst,
    input wire clk
);
    reg [DATA_WIDTH-1:0] d_reg;
    generate
        if (CLOCK_EDGE == 1) begin : posedge_clk
            always @ (posedge clk or posedge rst)
                begin
                    if (rst) begin
                        d_reg <= {DATA_WIDTH{1'b0}};
                    end else begin
                        d_reg <= {d_reg[DATA_WIDTH-2:0], d_in};
                    end
                end
        end else begin : negedge_clk
            always @ (negedge clk or posedge rst)
                begin
                    if (rst) begin
                        d_reg <= {DATA_WIDTH{1'b0}};
                    end else begin
                        d_reg <= {d_reg[DATA_WIDTH-2:0], d_in};
                    end
                end
        end
    endgenerate

    assign q_out = out_enable_in ? d_reg : 1'bz;

endmodule
```

## Simulacion

### Testbench en verilog

```verilog
`include "sipo.v"
`timescale 1ns / 1ps


module sipo_tb;
    // Declaración de señales
    reg d_in;
    wire [3:0] q_out;
    reg out_enable_in;
    reg rst;
    reg clk = 0;

    reg [3:0] d_reg = 4'b1001; // Registro interno para verificar el estado
    integer i;

    sipo #(
        .DATA_WIDTH(4),
        .CLOCK_EDGE(1)
    ) dut (
        .d_in(d_in),
        .q_out(q_out),
        .out_enable_in(out_enable_in),
        .rst(rst),
        .clk(clk)
    );

    always #10 clk = ~clk;

    initial begin
        $dumpfile("sipo.vcd");
        $dumpvars(0, sipo_tb);
    end

    initial begin
        out_enable_in = 1;
        rst = 1; // Activar el reset inicialmente
        #20; // Espera para permitir que el reset se aplique
        rst = 0;

        #20 
        for (i = 0; i < 4; i = i + 1) begin
            d_in = d_reg[i];
            #20; // Espera para permitir que el registro se actualice
        end
        #80
        rst = 1; // Activar el reset
        #20;
        rst = 0; // Desactivar el reset
        out_enable_in = 0; // Desactivar la salida

        #40 $finish;
    end
endmodule
```

### Testbench en Python (Cocotb)

```python
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge
logger = cocotb.logging.getLogger("cocotb")

PRESET_VALUES = [1, 0, 0, 1]  # Valores a cargar en el registro

@cocotb.test()
async def sipo_tb(dut):
    # Inicializar el reloj
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())

    # Resetear el DUT
    dut.out_enable_in.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    assert dut.q_out.value.integer == 0, "Error: Expected initial output to be 0"

    # Cargar los valores en el registro SIPO
    for value in PRESET_VALUES:
        dut.d_in.value = value
        logger.info(f"Loading value: {value}")
        await RisingEdge(dut.clk)

    # Verificar el contenido del registro SIPO
    await RisingEdge(dut.clk)
    assert dut.q_out.value.integer == 9, f"Expected 9, got {dut.q_out.value}"

    # Verificar el estado del registro cuando no se permite la salida
    dut.out_enable_in.value = 0
    await RisingEdge(dut.clk)
    assert str(dut.q_out.value) == "z" or "z" in str(dut.q_out.value), f"Error: Expected high impedance, got {dut.q_out.value}"
```
