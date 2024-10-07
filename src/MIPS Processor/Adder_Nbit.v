`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 05:28:50 PM
// Design Name: 
// Module Name: Adder_Nbit
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


module Adder_Nbit #(parameter N = 4)(
        input [N - 1:0]a, b,
        output [N - 1:0]c
    );
    assign c = a + b;
endmodule
