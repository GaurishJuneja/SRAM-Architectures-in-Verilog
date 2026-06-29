`timescale 1ns/1ps

module sram_dp_tb;

parameter DATA_WIDTH = 16;
parameter DEPTH = 256;

reg clk_A = 0;
reg clk_B = 0;

reg we_A = 0;
reg we_B = 0;

reg re_A = 0;
reg re_B = 0;

reg cs = 1;

reg [DATA_WIDTH-1:0] data_inA;
reg [DATA_WIDTH-1:0] data_inB;

reg [$clog2(DEPTH)-1:0] addr_A;
reg [$clog2(DEPTH)-1:0] addr_B;

wire [DATA_WIDTH-1:0] data_outA;
wire [DATA_WIDTH-1:0] data_outB;

wire collision;

sram_dp #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
)
DUT
(
    .clk_A(clk_A),
    .clk_B(clk_B),

    .we_A(we_A),
    .we_B(we_B),

    .re_A(re_A),
    .re_B(re_B),

    .cs(cs),

    .data_inA(data_inA),
    .data_inB(data_inB),

    .addr_A(addr_A),
    .addr_B(addr_B),

    .data_outA(data_outA),
    .data_outB(data_outB),

    .collision(collision)
);

always #5 clk_A = ~clk_A;
always #7 clk_B = ~clk_B;

initial begin

    $dumpfile("dp_ram_true_tb.vcd");
    $dumpvars(0,sram_dp_tb);

    //-----------------------
    // Initialize
    //-----------------------
    addr_A = 0;
    addr_B = 0;

    data_inA = 0;
    data_inB = 0;

    //-----------------------
    // Write AAAA @5
    //-----------------------
    @(negedge clk_A);

    addr_A = 5;
    data_inA = 16'hAAAA;
    we_A = 1;

    @(negedge clk_A);
    we_A = 0;

    //-----------------------
    // Write BBBB @10
    //-----------------------
    @(negedge clk_B);

    addr_B = 10;
    data_inB = 16'hBBBB;
    we_B = 1;

    @(negedge clk_B);
    we_B = 0;

    //-----------------------
    // Read Port A
    //-----------------------
    @(negedge clk_A);

    addr_A = 5;
    re_A = 1;

    @(negedge clk_A);
    re_A = 0;

    //-----------------------
    // Read Port B
    //-----------------------
    @(negedge clk_B);

    addr_B = 10;
    re_B = 1;

    @(negedge clk_B);
    re_B = 0;

    //-----------------------
    // Simultaneous
    // Write A / Read B
    //-----------------------
    @(negedge clk_A);

    addr_A = 15;
    data_inA = 16'h1234;
    we_A = 1;

    @(negedge clk_B);

    addr_B = 5;
    re_B = 1;

    @(negedge clk_A);
    we_A = 0;

    @(negedge clk_B);
    re_B = 0;

    //-----------------------
    // Verify write
    //-----------------------
    @(negedge clk_A);

    addr_A = 15;
    re_A = 1;

    @(negedge clk_A);
    re_A = 0;

    //-----------------------
    // Simultaneous read
    //-----------------------
    @(negedge clk_A);

    addr_A = 5;
    re_A = 1;

    @(negedge clk_B);

    addr_B = 15;
    re_B = 1;

    @(negedge clk_A);
    re_A = 0;

    @(negedge clk_B);
    re_B = 0;

    //-----------------------
    // Store initial value
    //-----------------------
    @(negedge clk_A);

    addr_A = 20;
    data_inA = 16'hAAAA;
    we_A = 1;

    @(negedge clk_A);
    we_A = 0;

    //-----------------------
    // Collision
    //-----------------------
    @(negedge clk_A);

    addr_A = 20;
    data_inA = 16'h1111;
    we_A = 1;

    @(negedge clk_B);

    addr_B = 20;
    data_inB = 16'h2222;
    we_B = 1;

    @(negedge clk_A);
    we_A = 0;

    @(negedge clk_B);
    we_B = 0;

    //-----------------------
    // Read after collision
    //-----------------------
    @(negedge clk_A);

    addr_A = 20;
    re_A = 1;

    @(negedge clk_A);
    re_A = 0;

    #30;

    $finish;

end

initial begin

    $monitor(
"T=%0t | Coll=%b | A:(WE=%b RE=%b Addr=%0d Din=%h Dout=%h) | B:(WE=%b RE=%b Addr=%0d Din=%h Dout=%h)",
    $time,
    collision,
    we_A,re_A,addr_A,data_inA,data_outA,
    we_B,re_B,addr_B,data_inB,data_outB
    );

end

endmodule