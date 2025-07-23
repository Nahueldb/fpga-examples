# Contador universal

- [Contador universal](#contador-universal)
  - [Descripcion](#descripcion)
  - [Codigo](#codigo)
    - [Verilog](#verilog)
  - [Simulacion](#simulacion)
    - [Testbench en verilog](#testbench-en-verilog)
    - [Testbench en Python (Cocotb)](#testbench-en-python-cocotb)

## Descripcion

Un contador universal es un circuito secuencial que puede contar en diferentes modos, como contar hacia arriba, hacia abajo o cargar un valor específico. Este tipo de contador es útil en aplicaciones donde se requiere flexibilidad en la operación del conteo.

## Codigo

### Verilog

```verilog
module contador_universal #(
    parameter N = 4,               // Cantidad de bits
    parameter MOD = 16,              // Módulo del contador
    parameter CLK_EDGE = 1         // 1 para flanco ascendente, 0 para descendente
)(
    input wire clk,
    input wire rst,                // Reset asincrónico
    input wire load_in,              // Carga por D
    input wire [N-1:0] d_in,         // Valor de carga
    input wire out_enable_in,        // Habilita la salida
    input wire counter_enable_in,    // Habilita el conteo
    input wire count_up_in,          // 1 = up, 0 = down
    input wire clk_edge_in,
    output wire [N-1:0] q_out,        // Salida del contador
    output reg terminal_count_out     // Indica fin de cuenta
);
    reg  [N-1:0] r_reg = {N{1'b0}}; // Registro del contador
    reg  [N-1:0] r_load = {N{1'b1}};
    wire [N-1:0] r_next;


    always @ (posedge clk, posedge rst) 
        begin
            if(rst) begin
                r_reg <= {N{1'b0}};
                terminal_count_out <= 1'b0; // Resetear la señal de terminal count
            end else if (load_in && out_enable_in) begin
                r_reg <= d_in;
                r_load <= d_in;
                terminal_count_out <= 1'b0; // Resetear la señal de terminal count
            end else if (counter_enable_in) begin
                    r_reg <= r_next;
                    if (r_reg == {N{1'b0}} && !count_up_in) begin
                        terminal_count_out <= 1'b1;
                        r_reg <= r_load;
                    end else if (r_reg == MOD - 1 && count_up_in) begin
                        terminal_count_out <= 1'b1;
                        r_reg <= {N{1'b0}};
                    end
                end
        end

    assign r_next = count_up_in ? (r_reg + 1) : (r_reg - 1);

    assign q_out = out_enable_in ? r_reg : {N{1'bz}};

endmodule

```

## Simulacion

### Testbench en verilog

```verilog
`include "contador_universal.v"
`timescale 1ns / 1ps

module tb_contador_universal;

    // Declaración de señales
    reg clk = 0;
    reg rst;
    reg load_in;
    reg [3:0] d_in;
    reg out_enable_in;
    reg counter_enable_in;
    reg count_up_in;
    wire [3:0] q_out;
    wire terminal_count_out;

    // Instanciamos el DUT (Device Under Test)
    contador_universal #(
        .N(4),
        .MOD(16),
        .CLK_EDGE(1)
    ) dut (
        .clk(clk),
        .rst(rst),
        .load_in(load_in),
        .d_in(d_in),
        .out_enable_in(out_enable_in),
        .counter_enable_in(counter_enable_in),
        .count_up_in(count_up_in),
        .q_out(q_out),
        .terminal_count_out(terminal_count_out)
    );

    always #10 clk = ~clk; // Generador de reloj: 50 MHz → período de 20 ns

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("contador_universal.vcd");
        $dumpvars(0, tb_contador_universal);
    end

    // Estímulo inicial
    initial begin
        // Valores iniciales
        load_in = 0;
        d_in = 4'b0000;
        out_enable_in = 1;
        counter_enable_in = 1;
        count_up_in = 1;

        #60 rst = 1;
        // Liberar el reset
        #15 rst = 0;

        // Cargar un valor
        #20 load_in = 1; d_in = 4'b1010;
        #20 load_in = 0;

        // Deshabilitar el contador
        #80 count_up_in = 0;

        // Finalizar la simulación
        #60 $finish;
    end
endmodule
```

### Testbench en Python (Cocotb)

```python
import cocotb
from cocotb.triggers import Timer
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

PRESET_VALUE = 5  # Valor a cargar en el contador

async def setup(dut, count_up_in=1):
    """Helper function to set up the testbench."""
    clock = Clock(dut.clk, 10, units='ns')
    cocotb.start_soon(clock.start())

    dut.rst.value = 0
    dut.out_enable_in.value = 1
    dut.counter_enable_in.value = 1
    dut.count_up_in.value = count_up_in

    await RisingEdge(dut.clk)


@cocotb.test()
async def test_increment(dut):
    await setup(dut, count_up_in=1)

    for expected in range(1, 16):
        await RisingEdge(dut.clk)
        assert dut.q_out.value.integer == expected, f"Increment failed at {expected}, expected {expected} but got {dut.q_out.value.integer}"


@cocotb.test()
async def test_reset(dut):
    await setup(dut)
    dut.counter_enable_in.value = 1
    await RisingEdge(dut.clk)

    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    assert dut.q_out.value.integer == 0, "Reset failed: q_out != 0"
    dut.rst.value = 0


@cocotb.test()
async def test_decrement(dut):
    await setup(dut, count_up_in=0)
    await RisingEdge(dut.clk)

    for expected in range(15, -1, -1):
        assert dut.q_out.value.integer == expected, f"Decrement failed at {expected}, expected {expected} but got {dut.q_out.value.integer}"
        await RisingEdge(dut.clk)


@cocotb.test()
async def test_load_value(dut):
    await setup(dut)
    dut.load_in.value = 1
    dut.d_in.value = PRESET_VALUE 
    await RisingEdge(dut.clk)
    dut.load_in.value = 0
    await RisingEdge(dut.clk)
    assert dut.q_out.value.integer == 5, f"Load failed: expected 5 but got {dut.q_out.value.integer}"


@cocotb.test()
async def test_terminal_count_up(dut):
    await setup(dut, count_up_in=1)

    for _ in range(15):
        await RisingEdge(dut.clk)

    assert dut.terminal_count_out.value == 1, "Terminal count not reached when expected"
    assert dut.q_out.value.integer == PRESET_VALUE, "Counter did not reset to PRESET_VALUE after terminal count"
    # Reset terminal count
    dut.rst.value = 1
    await RisingEdge(dut.clk)

    assert dut.terminal_count_out.value == 0, "Terminal count not reset correctly"


@cocotb.test()
async def test_terminal_count_down(dut):
    await setup(dut, count_up_in=0)

    for _ in range(PRESET_VALUE, -1, -1):
        await RisingEdge(dut.clk)

    assert dut.terminal_count_out.value == 1, "Terminal count not reached when expected"
    assert dut.q_out.value.integer == 0, "Counter did not reset to 0 after terminal count"
    
    # Reset terminal count
    dut.rst.value = 1
    await RisingEdge(dut.clk)

    assert dut.terminal_count_out.value == 0, "Terminal count not reset correctly"
```
