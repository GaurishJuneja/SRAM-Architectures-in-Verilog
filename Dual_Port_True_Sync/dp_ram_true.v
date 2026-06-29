// True Dual-Port SRAM with Synchronous Read
// Collision detection included

module sram_dp #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 16
)(
    input clk_A,
    input clk_B,

    input we_A,
    input we_B,

    input re_A,
    input re_B,

    input cs,

    input [DATA_WIDTH-1:0] data_inA,
    input [DATA_WIDTH-1:0] data_inB,

    input [$clog2(DEPTH)-1:0] addr_A,
    input [$clog2(DEPTH)-1:0] addr_B,

    output reg [DATA_WIDTH-1:0] data_outA,
    output reg [DATA_WIDTH-1:0] data_outB,

    output collision
);

    // Memory array
    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    // Collision detection
    assign collision = cs &&
                       we_A &&
                       we_B &&
                       (addr_A == addr_B);

    //-------------------------
    // Port A
    //-------------------------
    always @(posedge clk_A) begin

        if(cs) begin

            if(we_A && !collision)
                mem[addr_A] <= data_inA;

            else if(re_A)
                data_outA <= mem[addr_A];

        end

    end

    //-------------------------
    // Port B
    //-------------------------
    always @(posedge clk_B) begin

        if(cs) begin

            if(we_B && !collision)
                mem[addr_B] <= data_inB;

            else if(re_B)
                data_outB <= mem[addr_B];

        end

    end

endmodule