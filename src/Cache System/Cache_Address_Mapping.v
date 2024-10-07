`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/08/2024 12:12:47 AM
// Design Name: 
// Module Name: Cache_Address_Mapping
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


module Cache_Address_Mapping
#(
    parameter ADDR_WIDTH = 32,            // Width of the address bus
              BLOCKS_NUM = 8              // Number of cache blocks
)(
    input  [ADDR_WIDTH - 1:0]             addr,           // Address input for cache operations
    
    output [$clog2(4 * BLOCKS_NUM) - 1:0] block_index,    // Index to select the cache block
    output [1:0]                          word_offset,    // Offset to select a word within a block
    output [ADDR_WIDTH - 1:0]             block_addr,     // Stores the address aligned to the block boundary
    output [$clog2(BLOCKS_NUM) - 1:0]     tag_index       // Index used to access cache tags
    );
    
    // Extract word offset (lower 2 bits) from the address
    assign word_offset = addr[1:0];
    
    wire [ADDR_WIDTH - 1:0] shifted_addr;        // Address after shifting by 2 to ignore word offset bits
    // Shift the address by 2 to remove the word offset and get the block address
    assign shifted_addr = addr >> 2;
    
    // Align the shifted address to block boundaries
    assign block_addr = {shifted_addr, 2'b00};   // Append 2'b00 to create block-aligned address
    
    // Select the cache block index by using a portion of the shifted address
    assign tag_index = shifted_addr[$clog2(BLOCKS_NUM) - 1:0];
    
    // Cache block index is tag_index shifted left by 2 to account for 4-word blocks
    assign block_index = tag_index << 2;
    
endmodule
