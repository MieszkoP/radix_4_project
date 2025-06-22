`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/22/2025 10:22:59 PM
// Design Name: 
// Module Name: radix_4_lut
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


module radix_4_lut(clock, reset, start, x_value, y_value, total_product, ready);
    input clock, reset, start;
    input[7:0] x_value, y_value;
    output reg ready;
    wire[10:0] x_value_exp;
    reg[3:0] current_state;
    reg[3:0] iter;
    reg[15:0] partial_product;
    output reg[15:0] total_product;
    
    reg[7:0] pseudo_y_bits;
    reg zero_for_easy_comparisons;
    assign x_value_exp[8:1] = x_value;
    assign x_value_exp[0] = 1'b0;
    assign x_value_exp[10:9] = 2'b11;
    
    parameter S0 = 4'h00, S1 = 4'h01, S2 = 4'h02, S3 = 4'h03, S4 = 4'h04, S5_1 = 4'h05,
    S5_2 = 4'h06, S5_3 = 4'h07, S5_4 = 4'h08, S5_5 = 4'h09, S5_6 = 4'h0a,
    S6 = 4'h0b, S7 = 4'h0c, S13 = 4'h0d;
    
    wire[15:0] y_value_real;
    assign y_value_real[15:8] = pseudo_y_bits;
    assign y_value_real[7:0] = y_value;
        
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
                //$display("x =%d y=%d", $signed(x_value), $signed(y_value));
                if(y_value[7] == 1) pseudo_y_bits <= 8'b11111111; else pseudo_y_bits <= 8'b00000000;
                if(start ==1) current_state <= S1;
            end
            S1: begin
                if(iter < 4) current_state <= S2; else current_state <= S7;
            end
            S2: begin
                partial_product <= y_value_real<<(iter<<1);
                case({x_value_exp[(iter<<1)+2], x_value_exp[(iter<<1)+1], x_value_exp[(iter<<1)]})
                    3'b000: current_state <= S6;
                    3'b001: current_state <= S5_3;
                    3'b010: current_state <= S5_3;
                    3'b011: current_state <= S5_4;
                    3'b100: current_state <= S5_1;
                    3'b101: current_state <= S5_2;
                    3'b110: current_state <= S5_2;
                    3'b111: current_state <= S6;   
             endcase
            end
            S5_1: begin
                total_product <= -(partial_product<<1) + total_product;
                current_state <= S6;
            end
            S5_2: begin
                total_product <= -(partial_product) + total_product;
                current_state <= S6;
            end
            S5_3: begin
                total_product <= partial_product + total_product;
                current_state <= S6;
            end
            S5_4: begin
                total_product <= (partial_product<<1) + total_product;
                current_state <= S6;
            end
            S6: begin
                iter <= iter+1;
                if(iter +1 < 4) current_state <= S2; else current_state <= S7; //Iter-1, bo nieblokujące przypisanie
            end
            S7: begin
                ready <= 1;
            end
            endcase
            end
        //$display("Stan: %d, iteracja: %d, suma: %d, partial_product: %d,  maska: %d %d %d, current_state, iter, $signed(total_product), partial_product, x_value_exp[(iter<<1)],  x_value_exp[(iter<<1)+1],  x_value_exp[(iter<<1)+2]);
        //$display("x =%d y=%d", x_value, y_value);
    end
    
endmodule
