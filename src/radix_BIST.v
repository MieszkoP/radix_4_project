`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2025 12:40:45 PM
// Design Name: 
// Module Name: radix_BIST
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


module radix_BIST(active_test, user_x, user_y, clk, user_start, user_reset, result, ready);
    input active_test;
    input[7:0] user_x;
    input[7:0] user_y;
    input user_start, user_reset;
    input clk;
    output wire[15:0] result;
    reg start, reset;
    reg[7:0] x, y;
    output wire ready;
    wire [7:0] x_from_generator, y_from_generator;
    wire start_from_generator, reset_from_generator;
    
    wire clk_for_bist;
    clock_divider clock_divider_instance(clk, clk_for_bist);
    generator_start_restart generator_start_restart_instance(active_test, clk, start_from_generator, reset_from_generator);
    generator generator_lfsr_instance(active_test, clk_for_bist, x_from_generator, y_from_generator);
    radix_4 radix_4_instance(clk, reset, start, x, y, result, ready);
    always @(*)
    begin
        if(active_test==1)
        begin
             start = start_from_generator;
             reset = reset_from_generator;
             x = x_from_generator;
             y = y_from_generator;
        end 
        else
        begin
             start = user_start;
             reset = user_reset;
             x = user_x;
             y = user_y;
        end
    end
endmodule
