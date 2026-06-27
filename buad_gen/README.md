# Baud Rate Generator (Verilog)
# Overview

The Baud Rate Generator is a fundamental module used in UART communication systems. It converts a high-frequency system clock into a lower-frequency timing signal (baud tick) required for serial data transmission.

This module generates a single-cycle pulse (baud_tick) at a rate defined by the desired baud rate.

# Features
Parameterized design (configurable clock and baud rate)
Generates precise baud timing
Produces 1-clock-cycle pulse output
Synthesizable and simulation-friendly
Suitable for UART TX and RX modules

# Concept

UART communication requires accurate timing. Since the system clock is much faster than the baud rate, a counter-based clock divider is used.

Formula:
DIVISOR = CLOCK_FREQUENCY / BAUD_RATE
 The module counts clock cycles up to DIVISOR and generates a tick.

#  Working Principle
A counter increments on every clock cycle.
When the counter reaches DIVISOR - 1:
Counter resets to 0
baud_tick is set to 1 for one clock cycle
Otherwise:
Counter continues counting
baud_tick remains 0

# Notes
baud_tick is HIGH for only 1 clock cycle
Ensure correct divisor calculation to avoid timing errors
