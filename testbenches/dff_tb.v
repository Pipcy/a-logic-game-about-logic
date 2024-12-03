`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/28/2024 09:56:15 AM
// Design Name: 
// Module Name: dff_tb
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


module dff_tb(

    );
    
    reg D, clk;
    wire Q, notQ;
    
    dff DUT(D, clk, Q, notQ);
    
    initial begin
        D = 0;
        clk = 0;
        #23 D = 1;
        #57 D = 0;
        #100 $finish;
    end
    
    always #2 clk = ~clk;
    
endmodule









