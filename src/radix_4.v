`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/31/2025 01:53:10 PM
// Design Name: 
// Module Name: radix_4
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


module radix_4(clock, reset, start, x_value, y_value, total_product, ready);
    input clock, reset, start;
    input[7:0] x_value, y_value;
    output reg ready;
    wire[10:0] x_value_exp;
    reg[3:0] current_state;
    reg[3:0] iter;
    reg[15:0] partial_product;
    output reg[15:0] total_product;
    reg zero_for_easy_comparisons;
    assign x_value_exp[8:1] = x_value;
    assign x_value_exp[0] = 1'b0;
    assign x_value_exp[10:9] = 2'b0;
    
    parameter S0 = 4'h00, S1 = 4'h01, S2 = 4'h02, S3 = 4'h03, S4 = 4'h04, S5 = 4'h05,
    S6 = 4'h06, S7 = 4'h07, S8 = 4'h08, S9 = 4'h09, S10 = 4'h0a,
    S11 = 4'h0b, S12 = 4'h0c, S13 = 4'h0d;
    
    always @(posedge clock)
    begin
        
    end
    
    always @(posedge clock)
    begin
        if(reset==1)
            begin
                current_state<=S0;
                ready <= 0;
                partial_product <= 16'd0;
                total_product <= 16'd0;
                iter <= 0;
            end
         else
            begin
            case(current_state)
            S0: begin
                if(start ==1) current_state <= S1;
            end
            S1: begin
                if(iter < 5) current_state <= S2; else current_state <= S7;
            end
            S2: begin
                partial_product <= y_value<<(iter<<1);
                if((x_value_exp[iter<<1] == x_value_exp[(iter<<1)+1]) && (x_value_exp[(iter<<1)+1] == x_value_exp[(iter<<1)+2]))
                    current_state <= S6;
                else 
                begin
                    if(1== x_value_exp[(iter<<1)+2])
                        current_state <= S3;
                    else 
                    begin
                        if(x_value_exp[(iter<<1)]== x_value_exp[(iter<<1)+1])
                            current_state <= S4;
                        else 
                        begin
                            current_state <= S5;
                        end
                    end
                end
            end
            S3: begin
                partial_product <= -partial_product;
                if(x_value_exp[(iter<<1)+1] == x_value_exp[iter<<1]) current_state <= S4; else current_state <= S5;
            end
            S4: begin
                partial_product <= partial_product << 1;
                current_state <= S5;
            end
            S5: begin
                total_product <= partial_product + total_product;
                current_state <= S6;
            end
            S6: begin
                iter <= iter+1;
                if(iter +1 < 5) current_state <= S2; else current_state <= S7; //Iter-1, bo nieblokujące przypisanie
            end
            S7: begin
                ready <= 1;
            end
            endcase
            end
        $display("Stan: %d, iteracja: %d, suma: %d, partial_product: %d,  maska: %d %d %d", current_state, iter, total_product, partial_product, x_value_exp[(iter<<1)],  x_value_exp[(iter<<1)+1],  x_value_exp[(iter<<1)+2]);
    end
    
endmodule
