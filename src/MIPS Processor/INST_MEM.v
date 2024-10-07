`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2024 07:52:05 PM
// Design Name: 
// Module Name: INST_MEM
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

/* 
Instruction memory takes in two inputs: A 32-bit Program counter and a 1-bit reset. 
The memory is initialized when reset is 1.
When reset is set to 0, Based on the value of PC, corresponding 32-bit Instruction code is output
*/

module INST_MEM(
    input reset,                    // Asynchronous reset signal
    input [31:0] PC,                // 32-bit Program Counter input
    output [31:0] instruction       // 32-bit output for the instruction code
    );
    
    reg [31:0] Memory [63:0];       // 32 locations of 32-bit wide memory (total of 1024 bits)
    
    // Under normal operation (reset = 0), we assign the instruction code based on PC
    assign instruction = Memory[PC >> 2]; // Fetch the instruction from memory based on PC (addressing by word)
    
    // Initializing memory when reset is high
    always @(posedge reset)
    begin
        if (reset)
            $readmemh("test.mem", Memory); // Load memory contents from the file "program2.mem"
    end
endmodule
