# Matrix Convolution Hardware Accelerator

This project implements a **hardware accelerator for matrix convolution** using an **FSM-based design and FPGA integration**. The accelerator is designed with an **Avalon-MM interface** to enable efficient communication with the processor. The goal is to offload computationally expensive convolution operations to hardware for improved performance over software-only implementations.

## Features
- **FSM-Based Hardware Design:** Optimized finite state machine (FSM) for controlling matrix convolution operations.
- **Hardware-Software Co-Design:** Integration of FPGA hardware with software applications using C and SystemVerilog.
- **Avalon-MM Interface:** Efficient communication between FPGA and processor via memory-mapped I/O.
- **Custom Component Creation:** Hardware module developed and integrated into Intel Quartus Prime.
- **Testbench & Simulation:** Verification of the design codes using SystemVerilog testbenches and simulated to observe the functionality.
- **Performance Benchmarking:** Comparison of software-only vs. hardware-accelerated convolution execution times.

## Tools Used
- Cadence Xecilium
- Intel Quartus Prime
- UBoot terminal
- VS Code

## Summary of Folders
matrix_conv_fsm - Contains the hardware implementation (system Verilog) for FSM-based matrix convolution.
my_embedded - Contains software integration files, Makefile, and hardware-software interfacing code.
output - Stores images from the simulation and test results.

## Analysis
Software-only approach is faster for small matrices but becomes inefficient for larger computations.
Hardware acceleration reduces CPU load and provides better scalability for large datasets.
Future improvements may include pipelining the design for reduced latency.
