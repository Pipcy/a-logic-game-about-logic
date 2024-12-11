`timescale 1ns / 1ps

module debouncer(
    input clk,
    input noisyb,
    output reg cleanb,
    output reg cleanb_edge
    );
    
//    localparam MAX = 2'b1010;
    reg [19:0] counter;
    reg old_clean;
//    reg locked;
    
    initial counter = 0;
    initial cleanb = 0;
    initial old_clean=0;
//    initial locked = 0;    
//    always @(posedge clk or negedge noisyb) begin
    
    
    always @(posedge clk) begin
    if(cleanb)begin
    cleanb_edge = 0;
    end
        if (~noisyb) begin
//            locked = 0;
            counter = 0;
            cleanb = 0;
            old_clean=0;
        end
        else begin
//            if (counter >= 10 & (locked == 0)) begin
            if (counter >= 200000) begin
    //        if (counter >= 200000 & (locked == 0)) begin
                cleanb = 1;
                if (old_clean==0)
                begin 
                old_clean =1;
                cleanb_edge =1;
                end
                else 
                begin 
                cleanb_edge =0;
                end
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













