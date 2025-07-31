# Registro PIPO

- [Registro PIPO](#registro-pipo)
  - [Descripcion](#descripcion)
    - [Tabla de verdad](#tabla-de-verdad)
  - [Codigo](#codigo)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)
    - [Testbench en Python (Cocotb)](#testbench-en-python-cocotb)

## Descripcion

El Registro PIPO (Parallel In Parallel Out) es un tipo de registro que permite la entrada y salida de datos en paralelo. Es utilizado para almacenar múltiples bits de información y es común en aplicaciones donde se requiere manipular datos en bloques.

### Tabla de verdad

| outEnable | reset |  d  | clock  | clockEnable |  q  |
|-----------|-------|-----|--------|-------------|-----|
|     0     |   x   |  x  |   x    |      x      | zz  |
|     1     |   1   |  x  |   x    |      x      | 00  |
|     1     |   0   | 00  |   ↑    |      1      | 00  |
|     1     |   0   | 01  |   ↑    |      1      | 01  |
|     1     |   0   | 10  |   ↑    |      1      | 10  |
|     1     |   0   | 11  |   ↑    |      1      | 11  |
|     1     |   0   | x   |↓, 0 o 1|      1      | q0  |
|     1     |   0   | x   |   x    |      0      | q0  |

## Codigo

### Verilog

```verilog
module pipo #(
    parameter DATA_WIDTH = 8,
    parameter CLOCK_EDGE = 1 // 1 para flanco ascendente, 0 para descendente
)(
    input wire [DATA_WIDTH-1:0] d_in,
    output wire [DATA_WIDTH-1:0] q_out,
    input wire out_enable_in,
    input wire rst,
    input wire clk,
    input wire clk_enable
);
    reg [DATA_WIDTH-1:0] d_reg;
    generate
        if (CLOCK_EDGE == 1) begin : posedge_clk
            always @ (posedge clk or posedge rst)
                begin
                    if (rst) begin
                        d_reg <= {DATA_WIDTH{1'b0}};
                    end else if (clk_enable) begin
                        d_reg <= d_in;
                    end
                end
        end else begin : negedge_clk
            always @ (negedge clk or posedge rst)
                begin
                    if (rst) begin
                        d_reg <= {DATA_WIDTH{1'b0}};
                    end else if (clk_enable) begin
                        d_reg <= d_in;
                    end
                end
        end
    endgenerate

    assign q_out = out_enable_in ? d_reg : {DATA_WIDTH{1'bz}};

endmodule
```

## Simulacion

### Testbench en verilog

```verilog
`include "pipo.v"
`timescale 1ns / 1ps


module pipo_tb;
    // Declaración de señales
    reg [7:0] d_in;
    wire [7:0] q_out;
    reg out_enable_in;
    reg rst;
    reg clk = 0;
    reg clk_enable;

    pipo #(
        .DATA_WIDTH(8),
        .CLOCK_EDGE(1)
    ) dut (
        .d_in(d_in),
        .q_out(q_out),
        .out_enable_in(out_enable_in),
        .rst(rst),
        .clk(clk),
        .clk_enable(clk_enable)
    );

    always #10 clk = ~clk;

    initial begin
        $dumpfile("pipo.vcd");
        $dumpvars(0, pipo_tb);
    end

    initial begin
        clk_enable = 1;
        out_enable_in = 1;
        rst = 0;

        #20 d_in = 8'b10101010;

        #20 clk_enable = 0;
        d_in = 8'b00000000;

        #80 clk_enable = 1;
        d_in = 8'b11110000;

        #20 clk_enable = 0;

        #20 rst = 1;

        #40 out_enable_in = 0;

        #40 $finish;
    end
endmodule
```

### Testbench en Python (Cocotb)

```python
import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge

PRESET_VALUES = [5, 20, 170]  # Valores a cargar en el registro


@cocotb.test()
async def test_pipo_functionality(dut):
    # Initialize clock
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.start_soon(clock.start())

    dut.out_enable_in.value = 1

    for value in PRESET_VALUES:
        dut.clk_enable.value = 1
        await RisingEdge(dut.clk)
        # Test writing to the register
        dut.d_in.value = value
        await RisingEdge(dut.clk)
        dut.clk_enable.value = 0  # Disable clock to hold the value
        dut.d_in.value = 0  # Clear input to avoid accidental writes
        await RisingEdge(dut.clk)
        assert dut.q_out.value.integer == value, f"Write failed: expected {value}, got {dut.q_out.value.integer}"


@cocotb.test()
async def test_reset(dut):
    # Initialize clock
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.start_soon(clock.start())

    # Reset the DUT
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    dut.rst.value = 0

    # Check initial state
    assert dut.q_out.value.integer == 0, "Reset failed: q_out != 0"


# Uncomment the following test if you want to test negative clock edge
# @cocotb.test()
# async def test_negative_clock_edge(dut):
#     clock = Clock(dut.clk, 10, units='ns')
#     cocotb.start_soon(clock.start())

#     dut.rst.value = 0
#     dut.clk_enable.value = 1
#     dut.d_in.value = 42
#     dut.out_enable_in.value = 1
#     await FallingEdge(dut.clk)
#     dut.clk_enable.value = 0
#     await FallingEdge(dut.clk)

#     assert dut.q_out.value.integer == 42, "Negative clock edge test failed: q_out != 42"


@cocotb.test()
async def test_output_enable(dut):
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.start_soon(clock.start())

    # Disable output enable
    dut.out_enable_in.value = 0
    await RisingEdge(dut.clk)
    assert str(dut.q_out.value) == "z" or "z" in str(dut.q_out.value), f"Error: salida no es alta impedancia, q_out = {dut.q_out.value}"
```
