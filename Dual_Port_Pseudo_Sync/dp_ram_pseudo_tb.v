`timescale 1ns/1ps

module sram_pdp_tb;

parameter DATA_WIDTH = 16;
parameter DEPTH = 256;

reg clk = 0;

reg cs = 1;

reg we_A = 0;
reg re_B = 0;

reg [DATA_WIDTH-1:0] data_inA;

reg [$clog2(DEPTH)-1:0] addr_A;
reg [$clog2(DEPTH)-1:0] addr_B;

wire [DATA_WIDTH-1:0] data_outB;

sram_pdp #(
    .DATA_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH)
)
DUT
(
    .clk(clk),
    .cs(cs),

    .we_A(we_A),
    .re_B(re_B),

    .data_inA(data_inA),

    .addr_A(addr_A),
    .addr_B(addr_B),

    .data_outB(data_outB)
);

always #5 clk = ~clk;

initial begin

    $dumpfile("dp_ram_pseudo_tb.vcd");
    $dumpvars(0,sram_pdp_tb);

    //-------------------------
    // Initialize
    //-------------------------
    addr_A = 0;
    addr_B = 0;
    data_inA = 0;

    //-------------------------
    // Write ABCD @12
    //-------------------------
    @(negedge clk);
    addr_A = 12;
    data_inA = 16'hABCD;
    we_A = 1;

    @(negedge clk);
    we_A = 0;

    //-------------------------
    // Read @12
    //-------------------------
    @(negedge clk);
    addr_B = 12;
    re_B = 1;

    @(negedge clk);
    re_B = 0;

    //-------------------------
    // Write 1234 @100
    //-------------------------
    @(negedge clk);
    addr_A = 100;
    data_inA = 16'h1234;
    we_A = 1;

    @(negedge clk);
    we_A = 0;

    //-------------------------
    // Read @100
    //-------------------------
    @(negedge clk);
    addr_B = 100;
    re_B = 1;

    @(negedge clk);
    re_B = 0;

    //-------------------------
    // Overwrite @100
    //-------------------------
    @(negedge clk);
    addr_A = 100;
    data_inA = 16'h5678;
    we_A = 1;

    @(negedge clk);
    we_A = 0;

    //-------------------------
    // Read updated value
    //-------------------------
    @(negedge clk);
    addr_B = 100;
    re_B = 1;

    @(negedge clk);
    re_B = 0;

    //-------------------------
    // Read old address
    //-------------------------
    @(negedge clk);
    addr_B = 12;
    re_B = 1;

    @(negedge clk);
    re_B = 0;

    //-------------------------
    // READ-DURING-WRITE TEST
    //-------------------------
    @(negedge clk);

    addr_A  = 50;
    addr_B  = 50;

    data_inA = 16'hDEAD;

    we_A = 1;
    re_B = 1;

    @(negedge clk);

    we_A = 0;
    re_B = 0;

    //-------------------------
    // Verify memory contents
    //-------------------------
    @(negedge clk);

    addr_B = 50;
    re_B = 1;

    @(negedge clk);

    re_B = 0;

    #20;

    $finish;

end

initial begin

$monitor(
"T=%0t | WE=%b RE=%b | AddrW=%0d AddrR=%0d | Din=%h Dout=%h",
$time,
we_A,
re_B,
addr_A,
addr_B,
data_inA,
data_outB
);

end

endmodule