# Single cycle MIPS Processor Integrated with Cache System

This project demonstrates the integration of a direct-mapped cache system with a MIPS processor. The cache is designed to optimize memory access by reducing latency and improving spatial locality through a block-based architecture. It employs a write-back strategy to further enhance memory performance and reduce traffic.

## Features

- **MIPS Processor Integration**: The cache system is integrated into a MIPS processor to work seamlessly with MIPS-based programs.
- **Cache Architecture**: The cache is divided into blocks, with each block containing four words. This allows fetching entire blocks from memory to take advantage of spatial locality.
- **Write-Back Strategy**: The cache uses a write-back strategy, ensuring more efficient memory access and reducing memory traffic.
- **Simulation and Verification**: The design was verified using simulation, ensuring functionality and performance by integrating it with MIPS-based programs.

## Cache Design Details

- **Block Size**: Each cache block contains four words.
- **Cache Fetching**: Fetching a block from memory instead of individual words helps in reducing latency costs.
- **Write-Back Strategy**: Data is written back to memory only when it is evicted from the cache, reducing the need for frequent writes to memory and improving performance.

## Project Structure

- `src/`: Contains the Verilog files for the MIPS processor and cache system design.
- `testbench/`: Contains testbenches for validating the cache functionality and processor integration.
- `sim/`: Results from the simulations showing the cache performance.
- `program/`: Simple MIPS assembly program used to test and verify the cache system.

## Requirements

- **Vivado**: For Verilog simulation and synthesis.
- **MIPS Assembly**: Programs used to test the cache integration.
- **Verilog**: The hardware description language used for designing the processor and cache.

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/moateff/MIPS-Processor-Integrated-with-Cache-System.git
