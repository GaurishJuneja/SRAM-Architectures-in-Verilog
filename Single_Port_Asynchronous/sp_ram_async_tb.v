`timescale 1ns/1ps

module sram_sp_as_tb;

    parameter DATA_WIDTH = 8;
    parameter DEPTH = 16;

    reg clk;
    reg we, re;
    reg [DATA_WIDTH-1:0] data_in;
    reg [$clog2(DEPTH)-1:0] addr;

    wire [DATA_WIDTH-1:0] data_out;

    sram_sp_as #(
        .DATA_WIDTH(DATA_WIDTH),
        .DEPTH(DEPTH)
    ) uut (
        .clk(clk),
        .we(we),
        .re(re),
        .data_in(data_in),
        .addr(addr),
        .data_out(data_out)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        we = 0;
        re = 0;
        addr = 0;
        data_in = 0;

        $dumpfile("sp_ram_async_tb.vcd");
        $dumpvars(0, sram_sp_as_tb);

        //----------------------------
        // Write 25 to address 0
        //----------------------------
        #10;
        addr = 0;
        data_in = 8'd25;
        we = 1;

        #10;
        we = 0;

        //----------------------------
        // Read address 0
        //----------------------------
        #10;
        addr = 0;
        re = 1;

        #10;
        re = 0;

        //----------------------------
        // Write 100 to address 5
        //----------------------------
        #10;
        addr = 5;
        data_in = 8'd100;
        we = 1;

        #10;
        we = 0;

        //----------------------------
        // Read address 5
        //----------------------------
        #10;
        addr = 5;
        re = 1;

        #10;
        re = 0;

        //----------------------------
        // Overwrite address 5
        //----------------------------
        #10;
        addr = 5;
        data_in = 8'd200;
        we = 1;

        #10;
        we = 0;

        //----------------------------
        // Read address 5 again
        //----------------------------
        #10;
        addr = 5;
        re = 1;

        #10;
        re = 0;

        //----------------------------
        // Write 55 to address 15
        //----------------------------
        #10;
        addr = 15;
        data_in = 8'd55;
        we = 1;

        #10;
        we = 0;

        //----------------------------
        // Read address 15
        //----------------------------
        #10;
        addr = 15;
        re = 1;

        #10;
        re = 0;

        #20;
        $finish;

    end

    initial begin
        $monitor("Time=%0t | WE=%b RE=%b | Addr=%0d | Data_in=%0d | Data_out=%0d",
                 $time,we,re,addr,data_in,data_out);
    end

endmodule