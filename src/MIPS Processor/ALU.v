`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/10/2024 05:56:32 PM
// Design Name: 
// Module Name: ALU
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
ALU module, which takes two operands of size 32-bits each and a 4-bit ALU_control as input.
Operation is performed on the basis of ALU_control value and output is 32-bit ALU_result. 
If the ALU_result is zero, a ZERO FLAG is set.
*/

/*
ALU Control lines | Function
-----------------------------
        000    Bitwise-AND
        001    Bitwise-OR
        010	   Add (A+B)
        110	   Subtract (A-B)
        101    Multiply
        111	   Set on less than
*/

module ALU(
    input      [31:0] in_a,         // 32-bit input operand A
    input      [31:0] in_b,         // 32-bit input operand B
    input      [2 :0] alu_control,  // 3-bit ALU control signal
    output reg [31:0] alu_result,   // 32-bit result of the ALU operation
    output reg        zero_flag     // Zero flag indicating if the result is zero
);
    
    localparam  AND      = 3'b000,
                OR       = 3'b001,
                ADD      = 3'b010,
                SUB      = 3'b110,
                SLT      = 3'b111,
                MUL      = 3'b101;

    always @(*)
    begin
        alu_result = 32'b0;          // Initialize alu_result to 0 (default value)
        zero_flag = 1'b1;            // Initialize zero_flag to 1 (will be updated later)
        
        case(alu_control)            // Select operation based on alu_control
            AND: alu_result = in_a & in_b;    // Perform bitwise AND operation
            OR : alu_result = in_a | in_b;    // Perform bitwise OR operation
            ADD: alu_result = in_a + in_b;    // Perform addition
            SUB: alu_result = in_a - in_b;    // Perform subtraction
            MUL: alu_result = in_a * in_b;    // Perform multiplication
            SLT: alu_result = (in_a < in_b) ? 32'b1 : 32'b0; // Set less than operation
            default: alu_result = 32'b0;     // Default case: set result to 0
        endcase
        
        if (alu_result == 32'b0)    // Check if the result is zero
            zero_flag = 1'b1;      // Set zero_flag to 1 if result is zero
        else
            zero_flag = 1'b0;      // Set zero_flag to 0 if result is not zero
    end

endmodule
