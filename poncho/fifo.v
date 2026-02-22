module fifo #(
    parameter DATA_WIDTH = 12,
    parameter FIFO_DEPTH = 4,
    parameter ADDR_WIDTH = $clog2(FIFO_DEPTH)
) (
    input wire clk,
    input wire rst,
    input wire wr_en,
    input wire rd_en,
    input wire [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output reg full,
    output reg empty
);
    reg [DATA_WIDTH-1:0] fifo_mem [FIFO_DEPTH-1:0];
    reg [ADDR_WIDTH-1:0] wr_ptr;
    reg [ADDR_WIDTH-1:0] rd_ptr;
    reg [ADDR_WIDTH:0] count;

    assign full  = (count == FIFO_DEPTH);
    assign empty = (count == 0);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
            count <= 0;
        end else begin
            if (wr_en && !full) begin
                fifo_mem[wr_ptr] <= data_in;
                wr_ptr <= (wr_ptr + 1);
                count <= count + 1;
            end
            if (rd_en && !empty) begin
                data_out <= fifo_mem[rd_ptr];
                rd_ptr <= (rd_ptr + 1);
                count <= count - 1;
            end
        end
    end

endmodule
