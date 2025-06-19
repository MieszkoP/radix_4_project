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
    
    always @(posedge clk)
    begin
    if(reset_to_generator == 0)
        begin
            if(counter==4'b0000)
            begin
                reset <= 1;
                start<= 0;
            end
            if(counter==4'b0001)
            begin
                reset <= 0;
            end
            if(counter==4'b0010)
            begin
                start <= 1;
            end
            if(counter==4'b0010)
            begin
                start <= 1;
            end
            if(counter==4'b0101)
            begin
                start <= 0;
            end
            counter = counter+1;
        end
        else
        begin
        counter <= 4'b0000;
        end
        //$display("Licznik: %d",counter);
    end
endmodule
