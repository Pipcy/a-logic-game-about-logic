`timescale 1ns / 1ps

module baud_rate_generator(
        input clk_100MHz,       // basys 3 clock
        input reset,            // reset
        output tick             // sample tick
    );
    //9600 baud
    parameter   N = 14,     // number of counter bits
//                M = 651;     // counter limit value
                M =    10416;
    // Counter Register
    reg [N-1:0] counter;        // counter value
    wire [N-1:0] next;          // next counter value
    
    // Register Logic
    always @(posedge clk_100MHz or posedge reset)
        if(reset)
            counter <= 0;
        else
            counter <= next;
            
    // Next Counter Value Logic
    assign next = (counter == (M-1)) ? 0 : counter + 1;
    
    // Output Logic
    assign tick = (counter == (M-1)) ? 1'b1 : 1'b0;
       
endmodule