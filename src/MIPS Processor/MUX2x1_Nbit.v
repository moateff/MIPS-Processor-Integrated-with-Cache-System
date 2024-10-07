`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/11/2024 03:02:54 AM
// Design Name: 
// Module Name: MUX2x1_32bit
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


module MUX2x1_Nbit #(parameter N = 4)(
    input  [N - 1:0] x0, x1,
    input            sel,
    output [N - 1:0] z
    );
    assign z = sel? x1 : x0;
endmodule
