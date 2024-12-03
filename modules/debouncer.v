`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2024 04:50:02 PM
// Design Name: 
// Module Name: part3b_debouncer
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


module debouncer(
    input clk,
    input noisyb,
    output reg cleanb
    );
    
//    localparam MAX = 2'b1010;
    reg [19:0] counter;
//    reg locked;
    
    initial counter = 0;
    initial cleanb = 0;
//    initial locked = 0;    
//    always @(posedge clk or negedge noisyb) begin
    
    
    always @(posedge clk) begin
        if (~noisyb) begin
//            locked = 0;
            counter = 0;
            cleanb = 0;
        end
        else begin
//            if (counter >= 10 & (locked == 0)) begin
            if (counter >= 10000) begin
    //        if (counter >= 200000 & (locked == 0)) begin
                cleanb = 1;
//                locked = 1;
                //?
                counter = 0;
            end else begin
//                cleanb = 0;
//                if (noisyb == 1 & locked == 0) begin
//                if (noisyb == 1) begin
                    counter = counter + 1;
//                end
            end
        end
    end
    
endmodule













