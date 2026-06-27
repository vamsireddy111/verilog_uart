`timescale 1ns/1ps

module baud_gen #(
    parameter CLK_FREQ  = 1000000,   // Reduced for simulation
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


module uart_tx (
    input clk,
    input rst,
    input tx_start,
    input [7:0] data_in,
    input baud_tick,
    output reg tx,
    output reg tx_busy
);

    localparam IDLE  = 2'b00;
    localparam START = 2'b01;
    localparam DATA  = 2'b10;
    localparam STOP  = 2'b11;

    reg [1:0] state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            tx        <= 1'b1;
            tx_busy   <= 0;
            shift_reg <= 0;
            bit_count <= 0;
        end else begin
            case (state)

                IDLE: begin
                    tx      <= 1'b1;
                    tx_busy <= 0;
                    if (tx_start) begin
                        shift_reg <= data_in;
                        state     <= START;
                        tx_busy   <= 1;
                    end
                end

                START: begin
                    if (baud_tick) begin
                        tx    <= 1'b0;
                        state <= DATA;
                    end
                end

                DATA: begin
                    if (baud_tick) begin
                        tx        <= shift_reg[0];
                        shift_reg <= shift_reg >> 1;
                        bit_count <= bit_count + 1;

                        if (bit_count == 7)
                            state <= STOP;
                    end
                end

                STOP: begin
                    if (baud_tick) begin
                        tx        <= 1'b1;
                        state     <= IDLE;
                        bit_count <= 0;
                    end
                end

            endcase
        end
    end

endmodule


module uart_tx_top (
    input clk,
    input rst,
    input tx_start,
    input [7:0] data_in,
    output tx,
    output tx_busy
);

    wire baud_tick;

    baud_gen bg (
        .clk(clk),
        .rst(rst),
        .baud_tick(baud_tick)
    );

    uart_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .data_in(data_in),
        .baud_tick(baud_tick),
        .tx(tx),
        .tx_busy(tx_busy)
    );

endmodule
