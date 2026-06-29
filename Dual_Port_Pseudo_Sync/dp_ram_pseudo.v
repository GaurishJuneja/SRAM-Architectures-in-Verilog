// Pseudo Dual-Port SRAM with Synchronous Read
// Write-First Read-During-Write behavior

module sram_pdp #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input clk,
    input cs,

    input we_A,
    input re_B,

    input [DATA_WIDTH-1:0] data_inA,

    input [$clog2(DEPTH)-1:0] addr_A,
    input [$clog2(DEPTH)-1:0] addr_B,

    output reg [DATA_WIDTH-1:0] data_outB
);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    always @(posedge clk) begin

        if(cs) begin

            // Read and Write to same address
            if(we_A && re_B && (addr_A == addr_B)) begin
                mem[addr_A] <= data_inA;
                data_outB   <= data_inA;
            end

            // Write only
            else if(we_A) begin
                mem[addr_A] <= data_inA;
            end

            // Read only
            else if(re_B) begin
                data_outB <= mem[addr_B];
            end

        end

    end

endmodule