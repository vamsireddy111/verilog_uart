`timescale 1ns/1ps

module tb_uart_rx;

    reg clk;
    reg rst;
    reg rx;

    wire [7:0] data_out;
    wire rx_done;

 
    uart_rx_top uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data_out(data_out),
        .rx_done(rx_done)
    );

    
    always #500 clk = ~clk;

    
    task send_byte;
        input [7:0] data;
        integer i;
        begin
            
            rx = 0;
            #(1000*1000);  

      
            for (i = 0; i < 8; i = i + 1) begin
                rx = data[i];
                #(1000*1000);
            end

           
            rx = 1;
            #(1000*1000);
        end
    endtask

    initial begin
        clk = 0;
        rst = 1;
        rx  = 1; 
        $dumpfile("uart_rx.vcd");
        $dumpvars(0, tb_uart_rx);

        #2000;
        rst = 0;

        #5000;
        send_byte(8'hA5);

        #2000000;

        $finish;
    end

endmodule
