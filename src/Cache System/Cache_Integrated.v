`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2024 05:00:12 AM
// Design Name: 
// Module Name: Cache_Integrated
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


module Cache_Integrated(
    input        clk,            // Clock signal
    input        reset,          // Reset signal
    input        read,
    input        write,
    input [31:0] addr,
    input [31:0] data_in,
    output[31:0] data_out
    );
    
    wire         cache_read;
    wire         cache_write;
    wire         mem_read;
    wire         hit;
    wire         invalid;
    wire         mem_addr;
    wire [31 :0] word_from_cache;
    wire [127:0] block_from_mem;
    
    // Instantiate the Cache_Data_Mem_Controller module
    Cache_Data_Mem_Controller controller (
        .word_offset(addr[1:0]),
        .read(read),
        .write(write),
        .hit(hit),
        .block_from_mem(block_from_mem),
        .word_from_cache(word_from_cache),
        .cache_read(cache_read),
        .cache_write(cache_write),
        .mem_read(mem_read),
        .invalid(invalid),
        .data_out(data_out)
    );
    
    // Instantiate the Cache_System module
    Cache_System #(
        .ADDR_WIDTH(32), 
        .DATA_WIDTH(32), 
        .BLOCKS_NUM(4)
    ) cache (
        .clk(clk),
        .reset(reset),
        .rd_en(cache_read),
        .wr_en(cache_write),
        .invalid(invalid),
        .addr(addr),
        .w_data(block_from_mem),
        .r_data(word_from_cache),
        .hit(hit)
    );
    
    // Instantiate the DATA_MEM module
    DATA_MEM data_memory(
        .clk(clk),
        .reset(reset),
        .addr(addr),
        .r_data(block_from_mem),
        .rd_en(mem_read),
        .wr_en(write),
        .w_data(data_in)
    );
    
endmodule


