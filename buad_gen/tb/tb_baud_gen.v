`timescale 1ns/1ps

module tb_baud_gen;

    reg clk;
    reg rst;
    wire baud_tick;

    baud_gen #(
        .CLK_FREQ(50000000),
        .BAUD_RATE(9600)
    ) uut (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

    // Clock generation (50 MHz → 20 ns period)
    always #10 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;

        $dumpfile("baud_gen.vcd");
        $dumpvars(0, tb_baud_gen);

        #50;
        rst = 0;

        #2000000;

        $finish;
    end

endmodule
