`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2024 01:31:34 AM
// Design Name: 
// Module Name: Cache_System
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Cache_System
#(
    parameter ADDR_WIDTH = 32,            // Width of the address bus
              DATA_WIDTH = 8,             // Width of the data bus
              BLOCKS_NUM = 8              // Number of cache blocks
)(
    input                         clk,            // Clock signal
    input                         reset,          // Reset signal (active high)
    input                         wr_en,          // Write enable signal for the cache
    input                         rd_en,          // Read enable signal for the cache
    input                         invalid,        // Invalidate cache block signal
    input  [ADDR_WIDTH - 1:0]     addr,           // Input address for cache operations
    input  [4 * DATA_WIDTH - 1:0] w_data,         // Write data (4 words of DATA_WIDTH)
    output [DATA_WIDTH - 1:0]     r_data,         // Read data (1 word of DATA_WIDTH)
    output                        hit             // Cache hit flag
    );
    
    // Internal wires to connect between Cache_Control and Cache_Mem
    wire [$clog2(4 * BLOCKS_NUM) - 1:0] block_index;   // Index to select the cache block
    wire [1:0]                          word_offset;   // Offset to select a word within a block
    
    // Instantiate the Cache_Control module
    Cache_Control #(
        .ADDR_WIDTH(ADDR_WIDTH), 
        .BLOCKS_NUM(BLOCKS_NUM)
    ) cache_control (
        .clk(clk),                  // Connect the clock signal
        .reset(reset),              // Connect the reset signal
        .addr(addr),                // Input address from the system
        .wr_en(wr_en),        // Write enable from the system
        .rd_en(rd_en),        // Read enable from the system
        .invalid(invalid),          // Invalidate signal
        .block_index(block_index),  // Output block index to connect to cache memory
        .word_offset(word_offset),  // Output word offset within the block
        .hit(hit)                   // Output cache hit flag
    );
           
    
    // Instantiate the Cache_Mem module
    Cache_Mem #(
        .ADDR_WIDTH(ADDR_WIDTH), 
        .DATA_WIDTH(DATA_WIDTH), 
        .BLOCKS_NUM(BLOCKS_NUM)
    ) cache_mem (
        .clk(clk),                  // Connect the clock signal
        .reset(reset),              // Connect the reset signal
        .wr_en(wr_en),            // Write enable signal connected to write enable input
        .rd_en(rd_en),            // Read enable signal connected to read enable input
        .block_index(block_index),  // Input block index from Cache_Control
        .word_offset(word_offset),  // Input word offset from Cache_Control
        .data_in(w_data),           // Input write data (4 words)
        .data_out(r_data)           // Output read data (1 word)
    );

endmodule

