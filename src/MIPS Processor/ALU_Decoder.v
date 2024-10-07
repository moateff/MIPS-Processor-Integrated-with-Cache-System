`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 12:57:49 AM
// Design Name: 
// Module Name: ALU_Decoder
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


module ALU_Decoder(
    input      [1:0] alu_op,     // 2-bit ALU operation code from the control unit
    input      [5:0] funct,      // 6-bit function code from R-type instructions
    output reg [2:0] alu_control  // 3-bit ALU control signal determining the ALU operation
);

    localparam  ADD		= 6'b100000,
                SUB     = 6'b100010,
                AND     = 6'b100100,
                OR      = 6'b100101,
                SLT     = 6'b101010,
                SLL     = 6'b000000,
                SRL     = 6'b000010,
                JR      = 6'b001000,
                MUL     = 6'b011000,
                DIV     = 6'b011010;
               
    always @(*) begin
        case (alu_op)
            2'b00: alu_control = 3'b010; // LW, SW (add)
            2'b01: alu_control = 3'b110; // BEQ (subtract)
            2'b10: begin                // R-type instruction
                case(funct)
                    ADD:     alu_control = 3'b010; // ADD
                    SUB:     alu_control = 3'b110; // SUB
                    AND:     alu_control = 3'b000; // AND
                    OR :     alu_control = 3'b001; // OR
                    SLT:     alu_control = 3'b111; // SLT (Set Less Than)
                    MUL:     alu_control = 3'b101; //MUL
                    default: alu_control = 4'bxxxx; // Undefined
                endcase
            end
            default: alu_control = 4'bxxxx; // Undefined
        endcase
    end
endmodule
