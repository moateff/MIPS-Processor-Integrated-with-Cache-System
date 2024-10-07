`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2024 06:49:56 PM
// Design Name: 
// Module Name: REG_FILE
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
A register file can read two registers and write in to one register. 
The register file contains total of 32 registers each of size 32-bit. 
Hence 5-bits are used to specify the register numbers that are to be read or written. 
*/

/*
Register Read: Register file always outputs the contents of the register corresponding to read register numbers specified. 
Reading a register is not dependent on any other signals.

Register Write: Register writes are controlled by a control signal Write.  
Additionally the register file has a clock signal. 
The write should happen if Write signal is made 1 and if there is positive edge of clock. 
*/

module REG_FILE(
    input  [4 :0] r_addr1,  // 5-bit address for the first register read
    input  [4 :0] r_addr2,  // 5-bit address for the second register read
    output [31:0] r_data1,  // 32-bit data output for the first register
    output [31:0] r_data2,  // 32-bit data output for the second register
    input  [4 :0] w_addr,   // 5-bit address for the register to be written
    input         write_en, // Write enable signal
    input  [31:0] w_data,   // 32-bit data to be written to the register
    input         clk,      // Clock signal
    input         reset     // Reset signal
);

    reg [31:0] reg_memory [31:0]; // 32 memory locations each 32 bits wide
    integer i;
    
    always @(negedge clk or posedge reset)
    begin
        if (reset)
        begin
            // On reset, initialize all registers to their respective index values
            for (i = 0; i < 32; i = i + 1)
                reg_memory[i] = i;
        end
        else if (write_en)
        begin
            // On the rising edge of the clock, if write_enable is high, write w_data to the register at w_addr
            reg_memory[w_addr] = w_data;
        end
    end

    // The register file will always output the vaules corresponding to read register numbers 
    // It is independent of any other signal
    assign r_data1 = (r_addr1 != 0) ? reg_memory[r_addr1] : 0;
    assign r_data2 = (r_addr2 != 0) ? reg_memory[r_addr2] : 0;
endmodule
