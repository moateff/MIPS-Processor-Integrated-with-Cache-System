`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/03/2024 09:02:46 PM
// Design Name: 
// Module Name: Cache_Control
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

module Cache_Control  
#(
    parameter ADDR_WIDTH = 32,            // Width of the address bus
              BLOCKS_NUM = 8              // Number of cache blocks
)(
    input                                 clk,            // Clock signal
    input                                 reset,          // Reset signal (active high)
    input  [ADDR_WIDTH - 1:0]             addr,           // Address input for cache operations
    input                                 wr_en,          // Write enable signal for cache
    input                                 rd_en,          // Read enable signal for cache (not used in this module)
    input                                 invalid,        // Signal to invalidate a cache block
    output [$clog2(4 * BLOCKS_NUM) - 1:0] block_index,    // Index to select the cache block
    output [1:0]                          word_offset,    // Offset to select a word within a block
    output                                hit             // Cache hit flag
    );
    
    // Valid bits array: tracks which blocks are valid
    reg [0: BLOCKS_NUM - 1] valid;
    
    // Cache tags: stores the address tags for each block
    reg [ADDR_WIDTH - 1:0] cache_tags [0: BLOCKS_NUM - 1];
    
    wire [ADDR_WIDTH - 1:0]             block_addr;     // Stores the address aligned to the block boundary
    wire [$clog2(BLOCKS_NUM) - 1:0]     tag_index;      // Index used to access cache tags
    
    // Instantiate Cache_Address_Mapping
    Cache_Address_Mapping #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .BLOCKS_NUM(BLOCKS_NUM)
    ) cache_mapping (
        .addr(addr),                     // Input address
        .block_index(block_index),       // Output block index
        .word_offset(word_offset),       // Output word offset within the block
        .block_addr(block_addr),         // Output block-aligned address
        .tag_index(tag_index)            // Output tag index
    );
    
    // Cache hit logic: hit if the valid bit is set and the tags match the block address
    assign hit = (valid[tag_index] && (cache_tags[tag_index] == block_addr));
    
    integer i;    
    always @(negedge clk or posedge reset)
    begin
        if (reset)  // On reset, invalidate all cache blocks and clear the cache tags
        begin
            valid = 'b0;   // Invalidate all cache blocks
            for (i = 0; i < BLOCKS_NUM; i = i + 1)
                cache_tags[i] <= 'b0;  // Clear all cache tags
        end
        else
        begin 
            if (wr_en)  // If cache write is enabled
            begin
                cache_tags[tag_index] <= block_addr;  // Update the cache tag for the block
                valid[tag_index] <= 1'b1;             // Mark the block as valid
            end
            if (invalid)  // If invalidation is triggered
            begin
                valid[tag_index] <= 1'b0;             // Invalidate the block
            end
        end
    end
    
endmodule
