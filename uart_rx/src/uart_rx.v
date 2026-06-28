`timescale 1ns/1ps

module baud_gen #(
    parameter CLK_FREQ  = 1000000,
    parameter BAUD_RATE = 1000       
)(
    input clk,
    input rst,
    output reg baud_tick
);

    localparam DIVISOR = CLK_FREQ / BAUD_RATE;

    reg [15:0] counter;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter   <= 0;
            baud_tick <= 0;
        end else begin
            if (counter == DIVISOR - 1) begin
                counter   <= 0;
                baud_tick <= 1;
            end else begin
                counter   <= counter + 1;
                baud_tick <= 0;
            end
        end
    end

endmodule


module uart_rx (
    input clk,
    input rst,
    input rx,
    input baud_tick,
    output reg [7:0] data_out,
    output reg rx_done
);

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            data_out  <= 0;
            rx_done   <= 0;
        end else begin
            case (state)

                IDLE: begin
                    rx_done <= 0;
                    if (rx == 0)
                        state <= START;
                end

                START: begin
                    if (baud_tick) begin
                        if (rx == 0)
                            state <= DATA;
                        else
                            state <= IDLE;
                    end
                end

                DATA: begin
                    if (baud_tick) begin
                        shift_reg <= {rx, shift_reg[7:1]};
                        bit_count <= bit_count + 1;

                        if (bit_count == 7)
                            state <= STOP;
                    end
                end

                STOP: begin
                    if (baud_tick) begin
                        data_out  <= shift_reg;
                        rx_done   <= 1;
                        state     <= IDLE;
                        bit_count <= 0;
                    end
                end

            endcase
        end
    end

endmodule


module uart_rx_top (
    input clk,
    input rst,
    input rx,
    output [7:0] data_out,
    output rx_done
);

    wire baud_tick;

    baud_gen bg (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .baud_tick(baud_tick),
        .data_out(data_out),
        .rx_done(rx_done)
    );

endmodule
