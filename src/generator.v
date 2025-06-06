`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2025 11:42:45 AM
// Design Name: 
// Module Name: generator
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
// x16 + x5 + x3 + x2 + 1
// 
//////////////////////////////////////////////////////////////////////////////////


module generator(reset_generator, reset_radix, start_radix, clk, x, y);
    input reset_generator, clk;
    reg[15:0] register;
    output wire[7:0] x, y;
    output reg reset_radix, start_radix;
    assign x = register[15:8];
    assign y = register[7:0];
    always @(posedge clk)
    begin
        start_radix <=1;
        if(reset_generator==1)
            begin
            register[15] <= 1;
            register[14:0] <= 0;
            end
        else
            begin
            register[0] <= register[15];
            register[1] <= register[0];
            register[2] <= register[1]^register[15];
            register[3] <= register[2]^register[15];
            register[4] <= register[3];
            register[5] <= register[4]^register[15];
            register[6] <= register[5];
            register[7] <= register[6];
            register[8] <= register[7];
            register[9] <= register[8];
            register[10] <= register[9];
            register[11]<= register[10];
            register[12] <= register[11];
            register[13] <= register[12];
            register[14] <= register[13];
            register[15] <= register[14];
            end
    end
endmodule
