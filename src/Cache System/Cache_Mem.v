`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2024 06:27:36 PM
// Design Name: 
// Module Name: Cache_Mem
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

module Cache_Mem 
#(
    parameter ADDR_WIDTH = 32,           // Width of the address bus
              DATA_WIDTH = 8,            // Width of the data bus
              BLOCKS_NUM = 8             // Number of cache blocks
)(
    input                                 clk,            // Clock signal
    input                                 reset,          // Reset signal (active high)
    
    input                                 wr_en,           // Write enable signal
    input                                 rd_en,           // Read enable signal
    input  [$clog2(4 * BLOCKS_NUM) - 1:0] block_index,    // Index to select the cache block
    input  [1:0]                          word_offset,    // Offset within a block to select a word
    input  [4 * DATA_WIDTH - 1:0]         data_in,        // 4-word data to write to the cache
    
    output [DATA_WIDTH - 1:0]             data_out        // Output data (1 word)
    );

    // Cache memory array: stores 4 * BLOCKS_NUM words, each of size DATA_WIDTH
    reg [DATA_WIDTH - 1:0] cache_mem [0: 4 * BLOCKS_NUM - 1];
    
    integer i;  // Loop variable for reset initialization
    
    always @(negedge clk or posedge reset) 
    begin
        if (reset)  // On reset, initialize all cache memory elements to zero
        begin
            for (i = 0; i < 4 * BLOCKS_NUM; i = i + 1)
                cache_mem[i] = {DATA_WIDTH{1'b0}};   // Initialize each memory element with zeros
        end
        else if (wr_en)  // If write enable is high
        begin
            // Write 4 consecutive words starting from block_index
            {cache_mem[block_index + 3], cache_mem[block_index + 2], cache_mem[block_index + 1], cache_mem[block_index]} <= data_in;
        end
    end 

    // Read operation: Output the word from the selected block and byte offset if r_en is high, else high impedance ('bz')
    assign data_out = rd_en ? cache_mem[block_index + word_offset] : 'bz;

endmodule
