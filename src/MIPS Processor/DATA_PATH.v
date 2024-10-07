`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 03:50:02 PM
// Design Name: 
// Module Name: DATA_PATH
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


module DATA_PATH(
    input        reset,                //  Asynchrounus Active high reset.
    input        clk,                  //  System's clock.
    input [25:0] instruction,          //  The 32-bit Instruction from the instruction memory.
    input [31:0] read_data,            //  The output from the Data memory to the Register file.
    input [2:0]  alu_control,          //  Control signal from the CU to the RF.
    input         PC_src,              //  Control signal from the anding between zero_w & branch.
    input         mem_to_reg,          //  Control signal from the CU to the RF.
    input         alu_src,             //  Control signal from the CU to the RF.
    input         reg_dest,            //  Control signal from the CU to the RF.
    input         reg_write,           //  Control signal from the CU to the RF.
    input         jump,                //  Control signal from the CU to the RF.

    output        zero_flag,           //  Control signal from the ALU.
    output [31:0] PC,                  //  The Program Counter for the next instruction.
    output [31:0] alu_out,             //  ALU result.
    output [31:0] write_data           //  The data to be written into the data memory from the srcB.
    );
    
    wire [4:0] w_addr;
    wire [31:0] r_data2;
    wire [31:0] result;
    
        
    wire [31:0] src_a, src_b, alu_result;
    wire [15:0] immediate;   // 16-bit immediate value from the load/store instruction
    wire [31:0] sign_imm;    // Out from the Sign Extend unit.// Sign-extend the 16-bit immediate value to 32 bits

    assign immediate =  instruction[15:0]; 
    Sign_Extend sign_extend(
        .immediate_in(immediate),
        .immediate_out(sign_imm)
    );
        
    MUX2x1_Nbit #(.N(32)) mux1(
        .x0(r_data2), 
        .x1(sign_imm),
        .sel(alu_src),
        .z(src_b)
    );
    
    ALU alu(
        .in_a(src_a), 
        .in_b(src_b),
        .alu_control(alu_control),
        .alu_result(alu_result),
        .zero_flag(zero_flag)
    );  
    
    MUX2x1_Nbit #(.N(5)) mux2(
        .x0(instruction[20:16]), 
        .x1(instruction[15:11]),
        .sel(reg_dest),
        .z(w_addr)
    );
    
    REG_FILE register_file(
        .r_addr1(instruction[25:21]),
        .r_addr2(instruction[20:16]),
        .r_data1(src_a),
        .r_data2(r_data2),
        .w_addr(w_addr),
        .write_en(reg_write),
        .w_data(result),
        .clk(clk),
        .reset(reset)
    );
    
    MUX2x1_Nbit #(.N(32)) mux3(
        .x0(alu_result), 
        .x1(read_data),
        .sel(mem_to_reg),
        .z(result)
    );
    
    assign write_data = r_data2;
    assign alu_out = alu_result;
    
    wire [31:0] PC_next;     // Final next PC address
    
    D_FF_Nbit #(.N(32)) D_FF(
        .clk(clk),
        .reset(reset),
        .D(PC_next),
        .Q(PC)
    );
    
    wire [31:0] PC_plus4;    //  Output of the unit responsible of incrementing the pc.
    wire [31:0] PC_branch;   //  Output after adding the pc_plus4_w + shifted_imm_w.
    wire [31:0] PC_plus4_or_branch;   //  Output from the 2-1 MUX sel(pc_src_w).
    
    // Instantiate the Branch Target MUX
    MUX2x1_Nbit #(.N(32)) mux4(
        .x0(PC_plus4), 
        .x1(PC_branch),
        .sel(PC_src),
        .z(PC_plus4_or_branch)
    );
    
    wire [31:0] PC_jump;         // Calculated jump address

    // Instantiate the Instruction Address MUX
    MUX2x1_Nbit #(.N(32)) mux5(
        .x0(PC_plus4_or_branch), 
        .x1(PC_jump),
        .sel(jump),
        .z(PC_next)
    );
    
    Adder_Nbit #(.N(32)) adder1(
        .a(PC),
        .b(32'd4),
        .c(PC_plus4)
    );
    
    wire [31:0] shifted_imm; //  Shifted out from the Sign Extend unit.
    
    Shifter #(.shamt(2), .direction(1)) shifter1(
        .data_in(sign_imm),
        .data_out(shifted_imm)
    );
    
    Adder_Nbit #(.N(32)) adder2(
        .a(shifted_imm),
        .b(PC_plus4),
        .c(PC_branch)
    );
    
    wire [25:0] target;          // 26-bit target address from the J instruction
    wire [25:0] shifted_target;  // Shift the target address left by 2 bits
    
    assign target = instruction[25:0];
    Shifter #(.shamt(2), .direction(1)) shifter2(
        .data_in(target),
        .data_out(shifted_target)
    );
    
    // Concatenate the upper 4 bits of the PC with the shifted target address
    assign PC_jump = {PC[31:28], shifted_target};
    
endmodule
