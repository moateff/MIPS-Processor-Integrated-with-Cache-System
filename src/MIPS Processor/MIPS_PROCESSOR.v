`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 08:06:51 PM
// Design Name: 
// Module Name: MIPS_PROCESSOR
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


module MIPS_PROCESSOR(
    input         reset,
    input         clk,
    input  [31:0] instruction,
    output [31:0] PC,
    input  [31:0] read_data,
    output [31:0] alu_out,
    output [31:0] write_data,
    output        mem_write,
    output        mem_read
    );
    
    wire       reg_write;
    wire       reg_dest;
    wire       alu_src;
    wire       PC_src;
    wire       mem_to_reg;
    wire       jump;
    wire       zero_flag; 
    wire [2:0] alu_control;
    
    
    // Instantiate the CONTROL_UNIT module
    CONTROL_UNIT control_unit (
        .opcode(instruction[31:26]),
        .funct(instruction[5:0]),
        .zero_flag(zero_flag),
        .reg_write(reg_write),
        .reg_dest(reg_dest),
        .alu_src(alu_src),
        .PC_src(PC_src),
        .mem_write(mem_write),
        .mem_read(mem_read),
        .mem_to_reg(mem_to_reg),
        .jump(jump),
        .alu_control(alu_control)
    );
        
    // Instantiate the DATA_PATH module
    DATA_PATH data_path (
        .reset(reset),
        .clk(clk),
        .instruction(instruction[25:0]),
        .read_data(read_data),
        .alu_control(alu_control),
        .PC_src(PC_src),
        .mem_to_reg(mem_to_reg),
        .alu_src(alu_src),
        .reg_dest(reg_dest),
        .reg_write(reg_write),
        .jump(jump),
        .zero_flag(zero_flag),
        .PC(PC),
        .alu_out(alu_out),
        .write_data(write_data)
    );
    
endmodule
