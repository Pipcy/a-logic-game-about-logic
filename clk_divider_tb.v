`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2024 02:33:26 PM
// Design Name: 
// Module Name: clk_divider_testbench
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


module clk_divider_testbench(

    );
   
reg clk_in, rst, D;
    wire divided_clk;
    
    clk_divider clkd1( .clk_in(clk_in), .rst(rst), .divided_clk(divided_clk));
    
    dff DUT(D, divided_clk, Q, notQ);
    
    initial begin
        D = 0;
        clk_in = 0;
        rst = 0;
        #1 rst = 1;
        #20 rst = 0;
        #23 D = 1;
        #5 rst = 1;
        #7 rst = 0;
        #57 D = 0;
        #100 $finish;
    end
    
    always #2 clk_in = ~clk_in;
    
endmodule

