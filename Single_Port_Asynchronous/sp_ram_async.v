module sram_sp_as #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input clk,
    input we,
    input re,
    input [DATA_WIDTH-1:0] data_in,
    input [$clog2(DEPTH)-1:0] addr,
    output [DATA_WIDTH-1:0] data_out
);

    // Memory array
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Synchronous write
    always @(posedge clk) begin
        if (we)
            mem[addr] <= data_in;
    end

    // Asynchronous read
    assign data_out = (re) ? mem[addr] : {DATA_WIDTH{1'b0}};

endmodule