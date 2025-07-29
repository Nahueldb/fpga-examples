# Contador universal

- [Contador universal](#contador-universal)
  - [Descripcion](#descripcion)
  - [Codigo](#codigo)
    - [Codigo contador (Verilog)](#codigo-contador-verilog)
    - [Codigo Top Level (Verilog)](#codigo-top-level-verilog)
  - [Simulacion](#simulacion)
    - [Testbench en Verilog](#testbench-en-verilog)
    - [Testbench en Python (Cocotb)](#testbench-en-python-cocotb)

## Descripcion

Un contador universal es un circuito secuencial que puede contar en diferentes modos, como contar hacia arriba, hacia abajo o cargar un valor específico. Este tipo de contador es útil en aplicaciones donde se requiere flexibilidad en la operación del conteo.

## Codigo

### Codigo contador (Verilog)

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
    // input wire clk_edge_in,
    output wire [N-1:0] q_out,        // Salida del contador
    output reg terminal_count_out     // Indica fin de cuenta
);
    reg  [N-1:0] r_reg = {N{1'b0}}; // Registro del contador
    reg  [N-1:0] r_load = {N{1'b1}};
    wire [N-1:0] r_next;

    parameter COUNT_MAX = 10_000_000; // Retardo del contador para poder visualizarlo en la sintesis
                                      //En caso de ser 1 este retardo no tendra efecto y la cuenta se hara en cada flanco del clock

    reg [24:0] counter = 0;

    always @ (posedge clk, posedge rst) 
        begin
            if(rst) begin
                r_reg <= {N{1'b0}};
                terminal_count_out <= 1'b0; // Resetear la señal de terminal count
            end else if (load_in && out_enable_in) begin
                r_reg <= d_in;
                r_load <= d_in;
                terminal_count_out <= 1'b0; // Resetear la señal de terminal count
            end else if (counter_enable_in && counter == COUNT_MAX - 1) begin
                    counter <= 0;
                    r_reg <= r_next;
                    if (r_reg == {N{1'b0}} && !count_up_in) begin
                        terminal_count_out <= 1'b1;
                        r_reg <= r_load;
                    end else if (r_reg == MOD - 1 && count_up_in) begin
                        terminal_count_out <= 1'b1;
                        r_reg <= {N{1'b0}};
                    end
                end
            else begin
                counter <= counter + 1;
            end
        end

    assign r_next = count_up_in ? (r_reg + 1) : (r_reg - 1);

    assign q_out = out_enable_in ? r_reg : {N{1'bz}};

endmodule

```

### Codigo Top Level (Verilog)

```verilog
`include "contador_universal.v"
`include "bcd7seg.v"

module contador_display #(
    parameter N = 4,
    parameter MOD = 16,
    parameter CLK_EDGE = 1
)(
    input wire clk,
    input wire rst,
    input wire load_in,
    input wire [N-1:0] d_in,
    input wire out_enable_in,
    input wire counter_enable_in,
    input wire count_up_in,
    // input wire clk_edge_in,
    output wire terminal_count_out,
    output wire [6:0] sseg_out,
    output wire [3:0] digit_enable
);

    wire [N-1:0] contador_out;

    // Instancia del contador universal
    contador_universal #(
        .N(N),
        .MOD(MOD),
        .CLK_EDGE(CLK_EDGE)
    ) contador_inst (
        .clk(clk),
        .rst(rst),
        .load_in(load_in),
        .d_in(d_in),
        .out_enable_in(out_enable_in),
        .counter_enable_in(counter_enable_in),
        .count_up_in(count_up_in),
        // .clk_edge_in(clk_edge_in),
        .q_out(contador_out),
        .terminal_count_out(terminal_count_out)
    );

    // Instancia del decodificador BCD a display 7 segmentos
    bcd7seg display_inst (
        .bcd_in(contador_out),
        .sseg_out(sseg_out),
        .digit_enable(digit_enable)
    );

endmodule
```

## Simulacion

### Testbench en Verilog

```verilog
`include "contador_display.v"
`timescale 1ns / 1ps

module tb_contador_display;

    // Parámetros
    parameter N = 4;
    parameter MOD = 16;
    parameter CLK_EDGE = 1;

    // Señales de prueba
    reg clk = 0;
    reg rst;
    reg load_in;
    reg [N-1:0] d_in;
    reg out_enable_in;
    reg counter_enable_in;
    reg count_up_in;
    // reg clk_edge_in;
    wire terminal_count_out;
    wire [6:0] sseg_out;
    wire [3:0] digit_enable;


    wire [N-1:0] contador_out;

    // Instancia del contador display
    contador_display #(
        .N(N),
        .MOD(MOD),
        .CLK_EDGE(CLK_EDGE)
    ) dut (
        .clk(clk),
        .rst(rst),
        .load_in(load_in),
        .d_in(d_in),
        .out_enable_in(out_enable_in),
        .counter_enable_in(counter_enable_in),
        .count_up_in(count_up_in),
        // .clk_edge_in(clk_edge_in),
        .terminal_count_out(terminal_count_out),
        .sseg_out(sseg_out),
        .digit_enable(digit_enable)
    );
    

    always #10 clk = ~clk; // Generador de reloj: 50 MHz → período de 20 ns

    // Dump de señales para GTKWave
    initial begin
        $dumpfile("contador_display.vcd");
        $dumpvars(0, tb_contador_display);
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
from cocotb.clock import Clock, Timer
from cocotb.triggers import RisingEdge, ReadOnly


PRESET_VALUE = 5  # Valor a cargar en el contador
COMMON_ANODE = True  # Indica si el display de 7 segmentos es de ánodo común

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
        assert dut.sseg_out.value == get_7seg_encoding(expected), f"Increment failed at {expected}, expected {get_7seg_encoding(expected)} but got {dut.sseg_out.value.integer}"


@cocotb.test()
async def test_reset(dut):
    await setup(dut)
    dut.counter_enable_in.value = 1
    await RisingEdge(dut.clk)

    # Reset
    dut.rst.value = 1
    await RisingEdge(dut.clk)
    assert dut.sseg_out.value.integer == get_7seg_encoding(0), "Reset failed: sseg_out != 0"
    dut.rst.value = 0


@cocotb.test()
async def test_decrement(dut):
    await setup(dut, count_up_in=0)
    await RisingEdge(dut.clk)

    for expected in range(15, -1, -1):
        assert dut.sseg_out.value.integer == get_7seg_encoding(expected), f"Decrement failed at {expected}, expected {expected} but got {dut.sseg_out.value.integer}"
        await RisingEdge(dut.clk)


@cocotb.test()
async def test_load_value(dut):
    await setup(dut)
    dut.load_in.value = 1
    dut.d_in.value = PRESET_VALUE 
    await RisingEdge(dut.clk)
    dut.load_in.value = 0
    await RisingEdge(dut.clk)
    assert dut.sseg_out.value.integer == get_7seg_encoding(5), f"Load failed: expected 5 but got {dut.sseg_out.value.integer}"


@cocotb.test()
async def test_terminal_count_up(dut):
    await setup(dut, count_up_in=1)

    for _ in range(15):
        await RisingEdge(dut.clk)

    assert dut.terminal_count_out.value == 1, "Terminal count not reached when expected"
    assert dut.sseg_out.value.integer == get_7seg_encoding(PRESET_VALUE), "Counter did not reset to PRESET_VALUE after terminal count"
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
    assert dut.sseg_out.value.integer == get_7seg_encoding(0), "Counter did not reset to 0 after terminal count"

    # Reset terminal count
    dut.rst.value = 1
    await RisingEdge(dut.clk)

    assert dut.terminal_count_out.value == 0, "Terminal count not reset correctly"


def get_7seg_encoding(value, common_anode=COMMON_ANODE):
    """Returns the 7-segment encoding for a given value."""
    encoding = [
        0b1111110,  # 0
        0b0110000,  # 1
        0b1101101,  # 2
        0b1111001,  # 3
        0b0110011,  # 4
        0b1011011,  # 5
        0b1011111,  # 6
        0b1110000,  # 7
        0b1111111,  # 8
        0b1111011,  # 9
        0b1110111,  # A
        0b0011111,  # B
        0b1001110,  # C
        0b0111101,  # D
        0b1001111,  # E
        0b1000111   # F
    ]
    if common_anode:
        encoding = [~x & 0b1111111 for x in encoding]
        # print(encoding)
    # Return the encoding for the value, or None if out of range
    return encoding[value] if value < len(encoding) else None
```
