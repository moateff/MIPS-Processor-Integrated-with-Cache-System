`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 01:08:10 AM
// Design Name: 
// Module Name: Main_Decoder
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


module Main_Decoder(
    input [5:0] opcode,         // 6-bit opcode from the instruction
    output reg  reg_write,      // Control signal to enable writing to a register
    output reg  reg_dest,       // Control signal to select the destination register (for R-type instructions)
    output reg  alu_src,        // Control signal to select the second ALU operand source
    output reg  branch,         // Control signal for branching (whether to take a branch or not)
    output reg  mem_write,      // Control signal to enable writing to memory
    output reg  mem_read,
    output reg  mem_to_reg,     // Control signal to select the data source for register write (ALU or memory)
    output reg  [1:0] alu_op,   // 2-bit ALU operation code (part of the control signals for the ALU)
    output reg  jump            // Control signal to enable jumping to a target address
);
    
    localparam  R_type = 6'b000000, // R-type instructions
                LW     = 6'b100011, // Load Word
                SW     = 6'b101011, //Store Word
                BEQ    = 6'b000100, //Branch if Equal
                BNE    = 6'b000101, //Branch if Not Equal
                ADDI   = 6'b001000, //Add Immediate
                ANDI   = 6'b001100, //AND Immediate
                ORI    = 6'b001101, //OR Immediate
                SLTI   = 6'b001010, //Set Less Than Immediate
                LUI    = 6'b001111, //Load Upper Immediate
                JUMP   = 6'b000010, //Jump
                JAL    = 6'b000011; //Jump and Link
               
    always @(*) 
    begin
        reg_dest   = 0;
        alu_src    = 0;
        mem_to_reg = 0;
        reg_write  = 0;
        mem_write  = 0;
        mem_read   = 0;
        branch     = 0;
        alu_op     = 2'b00;
        jump       = 0;
        case (opcode)
            R_type : // R-type instruction
            begin 
                reg_dest = 1;
                reg_write = 1;
                alu_op = 2'b10;
             end
             LW :    // LW (Load Word)
             begin
                alu_src = 1;
                mem_to_reg = 1;
                mem_read = 1;
                reg_write = 1;
            end
            SW :     // SW (Store Word)
            begin
                alu_src = 1;
                mem_write = 1;
            end
            BEQ:     // BEQ (Branch on Equal)
            begin
                branch = 1;
                alu_op = 2'b01;
            end 
            ADDI:     // Add immediate
            begin
                alu_src = 1;
                reg_write = 1;
            end
            JUMP:     
            begin
                jump = 1;
            end
            default: 
            begin      // Undefined
                reg_dest   = 0;
                alu_src    = 0;
                mem_to_reg = 0;
                reg_write  = 0;
                mem_read   = 0;
                mem_write  = 0;
                branch     = 0;
                alu_op     = 2'b00;
                jump       = 0;
            end
        endcase
    end

endmodule
