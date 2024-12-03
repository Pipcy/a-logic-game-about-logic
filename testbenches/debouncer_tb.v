`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2024 05:01:03 PM
// Design Name: 
// Module Name: part3b_debounder_tb
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


module debounder_tb(

    );
    
    reg noisyb, clk;
    wire cleanb;
    
    part3b_debouncer db(clk, noisyb, cleanb);
    
    initial begin
        noisyb = 0; clk = 0;
        #7 noisyb = 1;
        #2 noisyb = 0;
        #7 noisyb = 1;
        #6 noisyb = 0;
        #12 noisyb = 1;
        #56 noisyb = 0;
        #10 $finish;
    end
    
    
    
    
    
    
    always #2 clk = ~clk;
    
    
    
    
    
    
endmodule
