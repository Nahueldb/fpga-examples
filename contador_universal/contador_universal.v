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