`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2025 02:14:00 PM
// Design Name: 
// Module Name: tb_radix_BIST
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


module tb_radix_BIST();
    reg clock, reset, start;
    reg [7:0] x, y;
    reg is_tested = 0'b1;
    wire ready;
    wire[15:0] result;
    
    radix_BIST instance_radix_BIST(is_tested, x, y, clock, start, reset, result, ready); //active_test, user_x, user_y, clk, user_start, user_reset, result, ready
    
    initial
    begin
        is_tested = 1'b0;
        #10 is_tested = 1'b1;
    end
    
    initial
    begin
        clock = 1;
        reset = 1;
        x = 8'b11111010;
        y = 8'b00000010;
        #10 reset <= 0;
        #10 start <= 1;
        #30 start <= 0;
    end
    
    always
    begin
        #5 clock <= ~clock;
    end
    
    always @(posedge ready)
    begin
        $display("wynik: %d", $signed(result));
    end
endmodule
