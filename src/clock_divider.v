`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2025 12:39:19 PM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(clk, output_clk);
    input clk;
    output reg output_clk;
    reg[4:0] counter = 4'b0000;
    always @(posedge clk)
    begin
        if(counter==4'b0000)
            output_clk <= 1;
        if(counter==4'b1111)
            output_clk <= 0;
        counter = counter+1;
    end
endmodule
