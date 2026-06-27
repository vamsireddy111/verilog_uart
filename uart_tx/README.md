# UART Transmitter (TX) in Verilog
# Overview

This project implements a UART (Universal Asynchronous Receiver Transmitter) Transmitter in Verilog.
It converts parallel 8-bit data into a serial bitstream following the UART protocol.

The design is modular and includes:

Baud Rate Generator
UART TX FSM (Finite State Machine)
Top-level integration module
Testbench with waveform dumping

# Architecture
            +------------------+
            |   Baud Generator |
            +--------+---------+
                     |
                 baud_tick
                     |
            +--------v---------+
            |     UART TX      |
            |   (FSM + Shift)  |
            +--------+---------+
                     |
                     v
                    tx (Serial Output)
# UART Frame Format

Each transmission frame follows:

| Start | Data Bits (8) | Stop |
|   0   | LSB → MSB     |  1   |

Example (data = 8'hA5 = 10100101):

TX Output:
1 (idle)
0 (start)
1 0 1 0 0 1 0 1 (data, LSB first)
1 (stop)

## Modules Description
# 1. Baud Generator (baud_gen.v)

Generates a single-cycle pulse (baud_tick) at the required baud rate.

Formula: DIVISOR = CLK_FREQ / BAUD_RATE

# 2. UART TX (uart_tx.v)

Implements FSM to transmit serial data.

States:
IDLE → Wait for tx_start
START → Send start bit (0)
DATA → Send 8 bits (LSB first)
STOP → Send stop bit (1)

# 3. Top Module (uart_tx_top.v)
Connects:
Baud Generator
UART TX module

# 4. Testbench (tb_uart_tx.v)
Generates clock and reset
Applies test stimulus
Dumps waveform using $dumpfile and $dumpvars


