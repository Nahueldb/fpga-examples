# Registro PISO

- [Registro PISO](#registro-piso)
  - [Descripcion](#descripcion)
    - [Tabla de verdad](#tabla-de-verdad)
  - [Codigo](#codigo)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)
    - [Testbench en Python (Cocotb)](#testbench-en-python-cocotb)

## Descripcion

El Registro PISO (Parallel In Serial Out) es un tipo de registro que permite la entrada de datos en paralelo y la salida en serie.


## Codigo

### Verilog

```verilog
module piso #(
    parameter DATA_WIDTH = 4,
    parameter CLOCK_EDGE = 1 // 1 para flanco ascendente, 0 para descendente
)(
    input wire [DATA_WIDTH-1:0] d_in,
    output wire q_out,
    input wire out_enable_in,
    input wire rst,
    input wire clk,
    input wire clk_enable,
    input wire load_enable_in
);
    reg [DATA_WIDTH-1:0] d_reg;
    generate
        if (CLOCK_EDGE == 1) begin : posedge_clk
            always @ (posedge clk or posedge rst)
                begin
                    if (rst) begin
                        d_reg <= {DATA_WIDTH{1'b0}};
                    end else if (load_enable_in) begin
                        d_reg <= d_in;
                    end else if (clk_enable) begin
                        d_reg <= {d_reg[DATA_WIDTH-2:0], 1'b0};
                    end
                end
        end else begin : negedge_clk
            always @ (negedge clk or posedge rst)
                begin
                    if (rst) begin
                        d_reg <= {DATA_WIDTH{1'b0}};
                    end else if (load_enable_in) begin
                        d_reg <= d_in;
                    end else if (clk_enable) begin
                        d_reg <= {d_reg[DATA_WIDTH-2:0], 1'b0};
                    end
                end
        end
    endgenerate

    assign q_out = out_enable_in ? d_reg[DATA_WIDTH-1] : 1'bz;

endmodule
```

## Simulacion

### Testbench en verilog

```verilog
`include "piso.v"
`timescale 1ns / 1ps


module piso_tb;
    // Declaración de señales
    reg [3:0] d_in;
    wire q_out;
    reg out_enable_in;
    reg rst;
    reg clk = 0;
    reg clk_enable;
    reg load_enable_in;

    reg [3:0] d_reg = 4'b1001; // Registro interno para verificar el estado
    integer i;

    piso #(
        .DATA_WIDTH(4),
        .CLOCK_EDGE(1)
    ) dut (
        .d_in(d_in),
        .q_out(q_out),
        .out_enable_in(out_enable_in),
        .rst(rst),
        .clk(clk),
        .clk_enable(clk_enable),
        .load_enable_in(load_enable_in)
    );

    always #10 clk = ~clk;

    initial begin
        $dumpfile("piso.vcd");
        $dumpvars(0, piso_tb);
    end

    initial begin
        out_enable_in = 1;
        clk_enable = 1;
        rst = 1;
        #20 rst = 0; // Desactivar el reset
        load_enable_in = 1;
        d_in = d_reg; // Cargar el registro con el valor inicial
        #20;
        load_enable_in = 0;
        #240
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

PRESET_VALUE = 5  # Valor a cargar en el registro
PRESET_VALUES = [0, 1, 0, 1]  # Valores esperados en cada ciclo de reloj

@cocotb.test()
async def piso_tb_functionality(dut):
    # Inicializar el reloj
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())

    dut.out_enable_in.value = 1
    await RisingEdge(dut.clk)
    dut.load_enable_in.value = 1
    await RisingEdge(dut.clk)
    dut.clk_enable.value = 1

    # Cargar los valores en el registro SISO
    dut.d_in.value = PRESET_VALUE
    await RisingEdge(dut.clk)
    dut.load_enable_in.value = 0
    await RisingEdge(dut.clk)

    # Verificar el contenido del registro SISO
    for expected_value in PRESET_VALUES:
        assert dut.q_out == expected_value, f"Expected {expected_value}, got {dut.q_out}"
        await RisingEdge(dut.clk)


@cocotb.test()
async def piso_tb_reset(dut):
    # Inicializar el reloj
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())

    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    # Verificar que el registro SISO se haya reiniciado
    assert dut.q_out == 0, f"Expected 0 after reset, got {dut.q_out}"


@cocotb.test()
async def piso_tb_output_enable(dut):
    # Inicializar el reloj
    cocotb.start_soon(Clock(dut.clk, 10, units='ns').start())

    dut.out_enable_in.value = 0
    await RisingEdge(dut.clk)

    # Verificar que la salida esté deshabilitada
    assert str(dut.q_out.value) == "z" or "z" in str(dut.q_out.value), f"Error: Expected high impedance, got {dut.q_out.value}"
```
