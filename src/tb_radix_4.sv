`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 02:08:38 PM
// Design Name: 
// Module Name: tb_radix_4
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


module tb_radix_4();
    reg clock, reset, start;
    reg [7:0] x, y;
    wire ready;
    wire[15:0] result;
    
    radix_4 instance_radix(clock, reset, start, x, y, result, ready);
    
    initial
    begin
        clock = 1;
        reset = 1;
        x = 8'd21;
        y = 8'd57;
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
        $display("wynik: %d", result);
    end
    
endmodule
