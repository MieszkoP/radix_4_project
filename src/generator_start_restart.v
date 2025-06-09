`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2025 12:03:17 PM
// Design Name: 
// Module Name: generator_start_restart
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


module generator_start_restart(reset_to_generator, clk, start, reset);
    input reset_to_generator;
    input clk;
    output reg start, reset;
    reg[4:0] counter = 4'b0000;
    
    always @(posedge reset_to_generator)
    begin
        counter <= 4'b0000;
    end
    
    always @(posedge clk)
    begin
    if(reset_to_generator)
        begin
            if(counter==4'b0000)
            begin
                reset <= 1;
            end
            if(counter==4'b0001)
            begin
                reset <= 0;
                start <= 1;
            end
            if(counter==4'b0010)
            begin
                start <= 0;
            end
            counter = counter+1;
        end
    end
endmodule
