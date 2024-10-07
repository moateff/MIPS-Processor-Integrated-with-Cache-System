`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 02:36:09 AM
// Design Name: 
// Module Name: CONTROL_UNIT
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


module CONTROL_UNIT(
    input  [5:0] opcode,       // 6-bit opcode from the instruction
    input  [5:0] funct,        // 6-bit function code (used for R-type instructions)
    input        zero_flag,    // Zero flag from the ALU (indicates if the result is zero)
    output       reg_write,    // Control signal to enable writing to a register
    output       reg_dest,     // Control signal to select the destination register (for R-type instructions)
    output       alu_src,      // Control signal to select the second ALU operand source
    output       PC_src,       // Control signal to select the source of the next PC value (branch or normal)
    output       mem_write,    // Control signal to enable writing to memory
    output       mem_read,
    output       mem_to_reg,   // Control signal to select the data source for register write (ALU or memory)
    output       jump,         // Control signal to enable jumping to a target address
    output [2:0] alu_control   // 3-bit control signal for the ALU operation
    );
    wire [1:0]   alu_op;        // 2-bit ALU operation code (part of the control signals for the ALU)
    wire         branch;        // Control signal for branching (whether to take a branch or not)

    
    // Instantiate the Main Decoder
    Main_Decoder main_decoder(
         .opcode(opcode),
         .reg_write(reg_write),
         .reg_dest(reg_dest),
         .alu_src(alu_src),
         .branch(branch),
         .mem_write(mem_write),
         .mem_read(mem_read),
         .mem_to_reg(mem_to_reg),
         .alu_op(alu_op),
         .jump(jump)
     );
     
     // Instantiate the ALU Decoder
     ALU_Decoder alu_decoder(
         .alu_op(alu_op),
         .funct(funct),
         .alu_control(alu_control)
     );
     
     assign PC_src = branch & zero_flag;
endmodule
