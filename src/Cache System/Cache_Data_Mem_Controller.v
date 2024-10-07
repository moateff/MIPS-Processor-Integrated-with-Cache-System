`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/05/2024 01:37:01 AM
// Design Name: 
// Module Name: Cache_Data_Mem_Controller
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


module Cache_Data_Mem_Controller(
    input  [1:0]   word_offset,
    input  [127:0] block_from_mem,
    input  [31:0]  word_from_cache,
    input          hit,
    input          read,
    input          write,
    
    output         mem_read,
    output         cache_read,
    output         cache_write,
    output         invalid,
    output [31:0]  data_out
    );
    
    assign mem_read = read & ~hit;
    assign cache_read = read & hit;
    assign cache_write = read & ~hit;
    assign invalid = write & hit;
    
    reg [31:0] word_from_mem;
    
    always @(block_from_mem or word_offset)
    begin
        case(word_offset)
            2'b00: word_from_mem = block_from_mem[31:0];
            2'b01: word_from_mem = block_from_mem[63:32];
            2'b10: word_from_mem = block_from_mem[95:64];
            2'b11: word_from_mem = block_from_mem[127:96];
            default:;
        endcase
    end
    
    assign data_out = read & hit ? word_from_cache : word_from_mem;
         
endmodule
