`timescale 1ns / 1ps

module misr(reset_to_misr, clk, result_of_radix, signature, ready);
    input reset_to_misr, clk;
    input[15:0] result_of_radix;
    output reg[15:0] signature;
    reg[5:0] counter_of_generated;
    output reg ready;

    
    always @(posedge clk)
    begin
        if(reset_to_misr==0)
        begin
            signature[15] <= 1;
            signature[14:0] <= 0;
            counter_of_generated <= 5'b00000; //Generate 2^5 =  32 pairs of numbers. 
            ready<=0;
        end
        if(reset_to_misr==1 && counter_of_generated<5'b11111)
            begin
            signature[0] <= signature[15]^result_of_radix[0];
            signature[1] <= signature[0]^result_of_radix[1];
            signature[2] <= (signature[1]^signature[15])^result_of_radix[2];
            signature[3] <= (signature[2]^signature[15])^result_of_radix[3];
            signature[4] <= signature[3]^result_of_radix[4];
            signature[5] <= (signature[4]^signature[15])^result_of_radix[5];
            signature[6] <= signature[5]^result_of_radix[6];
            signature[7] <= signature[6]^result_of_radix[7];
            signature[8] <= signature[7]^result_of_radix[8];
            signature[9] <= signature[8]^result_of_radix[9];
            signature[10] <= signature[9]^result_of_radix[10];
            signature[11]<= signature[10]^result_of_radix[11];
            signature[12] <= signature[11]^result_of_radix[12];
            signature[13] <= signature[12]^result_of_radix[13];
            signature[14] <= signature[13]^result_of_radix[14];
            signature[15] <= signature[14]^result_of_radix[15];
            counter_of_generated <= counter_of_generated +1;
            $display("Wynik: ", signature);
            $display("Sygnatura: ", signature);
            end
          if(counter_of_generated==5'b11111)
            ready<=1;
    end
endmodule
