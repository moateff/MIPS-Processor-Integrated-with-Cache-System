`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 12:18:13 AM
// Design Name: 
// Module Name: DATA_MEM
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

module DATA_MEM(
    input              clk,           // Clock signal
    input              reset,         // Asynchronous reset signal (for initializing memory)
    input      [31:0]  addr,          // 32-bit input for memory address
    input      [31:0]  w_data,        // 32-bit input for writing data into memory
    input              wr_en,         // Write enable signal (if high, data is written to memory)
    input              rd_en,         // Read enable signal (if high, data is read from memory)
    output reg [127:0] r_data         // 128-bit block (4 * 32-bit words) output for reading data from memory
);
    
    // Memory array: 64 locations, each 32-bit wide
    reg  [31:0] data_mem [0:63];  
    
    // Block address wire, used to calculate the block boundary of the memory access
    wire [31:0] block_addr;
    
    integer i; 
    always @(negedge clk or posedge reset)  
    begin 
        if (reset)  // If reset is high, initialize the memory
        begin
            // Loop through all memory locations (64 total) and initialize to 0
            for (i = 0; i < 64; i = i + 1)
                data_mem[i] = 32'b0;  // Set each memory location to 0
        end
        else if (wr_en)  // If write enable is high, write data to memory
        begin
            data_mem[addr] = w_data;  // Write the input data (w_data) to the memory at the specified address (addr)
        end
    end
    
    // Calculate block address by shifting right by 2 to ignore the word offset bits, and appending 2'b00
    assign block_addr = {(addr >> 2), 2'b00};
    
    always @(*)
    begin
        if(rd_en)
        begin
            // Read 4 words from memory starting from the calculated block address
            // Delay of 2 time units (#2) to model read latency
            r_data = 128'bx;
            #2 r_data = {data_mem[block_addr + 3], data_mem[block_addr + 2], data_mem[block_addr + 1], data_mem[block_addr]};  
        end
        else
        begin
            r_data = 128'bz;
        end
    end

    // assign #5 r_data = rd_en ? {data_mem[block_addr + 3], data_mem[block_addr + 2], data_mem[block_addr + 1], data_mem[block_addr]} : 128'bz;  

endmodule

