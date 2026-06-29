module sram_sp #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8
)(
    input clk,
    input we,
    input re,
    input [DATA_WIDTH-1:0] data_in,
    input [$clog2(DEPTH)-1:0] addr,
    output reg [DATA_WIDTH-1:0] data_out
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin
        if (we) begin
            mem[addr] <= data_in;
        end
        else if (re) begin
            data_out <= mem[addr];
        end
    end

endmodule