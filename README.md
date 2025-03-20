# Matrix Convolution Hardware Accelerator

This project implements a **hardware accelerator for matrix convolution** using an **FSM-based design and FPGA integration**. The accelerator is designed with an **Avalon-MM interface** to enable efficient communication with the processor. The goal is to offload computationally expensive convolution operations to hardware for improved performance over software-only implementations.

## Features
- **FSM-Based Hardware Design:** Optimized finite state machine (FSM) for controlling matrix convolution operations.
- **Hardware-Software Co-Design:** Integration of FPGA hardware with software applications using C and SystemVerilog.
- **Avalon-MM Interface:** Efficient communication between FPGA and processor via memory-mapped I/O.
- **Custom Component Creation:** Hardware module developed and integrated into Intel Quartus Prime.
- **Testbench & Simulation:** Verification of the hardware accelerator using SystemVerilog testbenches.
- **Performance Benchmarking:** Comparison of software-only vs. hardware-accelerated convolution execution times.

## 📁 Folder Structure
