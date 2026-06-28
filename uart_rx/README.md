# UART Receiver (UART RX) in Verilog
# Overview

This project implements a UART (Universal Asynchronous Receiver Transmitter) Receiver in Verilog.
The UART RX module converts serial input data (rx) into parallel 8-bit data (data_out) using a baud rate–synchronized sampling mechanism.

# Module Architecture
 1. Baud Generator (baud_gen)
Generates a baud tick pulse
Controls timing for sampling incoming bits
 2. UART RX Core (uart_rx)
Implements FSM to decode serial data
Uses shift register to assemble received bits
 3. Top Module (uart_rx_top)
Integrates baud generator and UART RX module
🔄 FSM (Finite State Machine)

The UART RX operates using the following states:

IDLE → START → DATA → STOP → IDLE
State	Description
IDLE	Wait for start bit (rx = 0)
START	Validate start bit
DATA	Receive 8 bits
STOP	Validate stop bit and output data

# UART Frame Format
Each transmitted frame follows:

Start Bit (0) + 8 Data Bits (LSB First) + Stop Bit (1)

Example for 8'hA5:

Idle → 0 → 1 0 1 0 0 1 0 1 → 1
# Key Concepts
 Mid-Bit Sampling
Data is sampled at the center of each bit
Prevents errors due to noise or timing mismatch
