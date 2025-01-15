# Verilog CPU Implementation

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Future Enhancements](#future-enhancements)
## Overview
This project is a Verilog implementation of a custom CPU designed with the following features:

- **Stack**: A dedicated stack for function calls and interrupt handling.
- **GPIO (General Purpose Input/Output)**: Interfaces to interact with external peripherals.
- **Timer**: A hardware timer for time-based operations.
- **Interrupt Handling**: Supports hardware and software interruptions.
- **AVR Instructions**: Compatible with a subset of AVR microcontroller instructions.

## Features

### 1. Stack
- **Purpose**: Manages function calls, returns, and interrupt handling.
- **Depth**: Configurable depth for handling multiple nested calls.

### 2. GPIO
- **Ports**: Configurable number of input/output ports.
- **Direction Control**: Each GPIO pin can be individually set as input or output.

### 3. Timer
- **Functionality**: Provides time-based interrupts and periodic operations.
- **Modes**: Supports countdown and overflow modes.
- **Configuration**: Adjustable timer period and prescaler values.

### 4. Interrupt Handling
- **Interrupt Types**: Hardware and software interrupts supported.
- **Prioritization**: Configurable interrupt priority levels.
- **Interrupt Vector Table**: Maps interrupt requests to their service routines.

### 5. AVR Instruction Compatibility
- **Supported Instructions**: Implements a subset of the AVR instruction set, including arithmetic, logical, and branching instructions.
- **Registers**: Emulates AVR register file for compatibility.

## Architecture
The CPU architecture includes the following components:

1. **Instruction Fetch Unit**: Fetches instructions from program memory.
2. **Instruction Decode Unit**: Decodes instructions into control signals.
3. **Execution Unit**: Executes instructions and performs arithmetic and logical operations.
4. **Memory Unit**: Interfaces with program memory and data memory.
5. **Interrupt Controller**: Handles interrupts and manages the interrupt vector table.
6. **GPIO Controller**: Manages input and output through GPIO pins.
7. **Timer Module**: Implements the timer functionality.
8. **Stack Unit**: Manages the call stack and interrupt stack.

### Prerequisites
- **Tools Required**:
- Either:
  - Verilog simulator (e.g., ModelSim, XSIM)
- Or:
  - FPGA synthesis tool (e.g., Vivado, Quartus) and FPGA board for hardware implementation.
## Future Enhancements
- Support for additional AVR instructions.

