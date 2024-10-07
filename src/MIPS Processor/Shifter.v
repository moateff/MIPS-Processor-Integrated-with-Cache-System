`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 12:06:14 AM
// Design Name: 
// Module Name: Shifter
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


module Shifter#(parameter shamt = 2, direction  = 1)(
    input [31:0] data_in,
    output [31:0] data_out
);
    assign data_out = direction ? (data_in << shamt) : (data_in >> shamt);
endmodule