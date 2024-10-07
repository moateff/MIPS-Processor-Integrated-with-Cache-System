`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 08:38:04 PM
// Design Name: 
// Module Name: MIPS_ARCHITECTURE
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


module MIPS_ARCHITECTURE(
    input         clk,                //  System's clock
    input         reset,              //  Asynchrounus Active high reset
    output [31:0] read_data,          //  The data read from the data memory.
    output [31:0] write_data          //  The data to be written in the data memory.
);
    wire [31:0] instruction;  //  Intsruction fetched from the Instruction Memory.
    wire [31:0] PC;           //  The Program Counter out from the data path unit.
    wire [31:0] alu_out;      //  ALU result.
    wire        write;    //  Control signal from the Control Unit to the Data memory.
    wire        read;
    
    wire [31:0] w_write_data;
    assign write_data = write ? w_write_data : 'bx;
    
    // Instantiate the MIPS_PROCESSOR module
    MIPS_PROCESSOR mips_processor(
        .reset(reset),
        .clk(clk), 
        .instruction(instruction),
        .read_data(read_data),
        .PC(PC),
        .alu_out(alu_out),
        .write_data(w_write_data),
        .mem_write(write),
        .mem_read(read)
    );
    
    // Instantiate the IFU module
    INST_MEM instruction_memory(
        .reset(reset),
        .PC(PC),
        .instruction(instruction)
    );
    
    // Instantiate the Cache_Integrated module
    Cache_Integrated Memory(
        .clk(clk),           
        .reset(reset),       
        .read(read),
        .write(write),
        .addr(alu_out),
        .data_in(w_write_data),
        .data_out(read_data)
    );
    
    /*    
    // Instantiate the DATA_MEM module
    DATA_MEM data_memory(
        .addr(alu_out),
        .r_data(read_data),
        .w_data(write_data),
        .rd_en(mem_read),
        .wr_en(mem_write),
        .clk(clk),
        .reset(reset)
    );
    */
endmodule
