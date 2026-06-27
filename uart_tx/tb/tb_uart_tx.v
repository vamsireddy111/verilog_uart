`timescale 1ns/1ps

module tb_uart_tx;

    reg clk;
    reg rst;
    reg tx_start;
    reg [7:0] data_in;

    wire tx;
    wire tx_busy;

    uart_tx_top uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .data_in(data_in),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    always #500 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        tx_start = 0;
        data_in = 8'hA5;  // Test data

        $dumpfile("uart_tx.vcd");
        $dumpvars(0, tb_uart_tx);

        #2000;
        rst = 0;

        #2000;
        tx_start = 1;

        #1000;
        tx_start = 0;

        #200000;

        $finish;
    end

endmodule
