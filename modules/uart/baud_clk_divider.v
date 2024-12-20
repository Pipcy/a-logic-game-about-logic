`timescale 1ns / 1ps

/*
 * This clock divider slows the clock from the FPGA's built-in 100 MHz to
 * a baud rate of 9600 to facilitate UART communication.
 */

module baud_clk_divider(
    input clk_in,
    input rst,
    output reg clk_out
    );
    
    // To achieve a baud rate of 9600, we need to divide the clock by a factor of:
    // 100,000,000 / 9,600 = 10,416
//    parameter toggle_value = 10416;
    parameter toggle_value = 2;

    reg [31:0] counter;
    reg [31:0] next;

    always @(posedge clk_in or posedge rst) begin
        if (rst) begin
            counter <= 0;
            clk_out <= 0;
//        end else counter <= next;
        end else begin
        
        // only stay high for one clock cycle
//        if (clk_out == 1) clk_out = 0;
//        else begin
//            if (counter == toggle_value) begin
//                next = 0;
//                clk_out = 1;
//                counter = 0;
//            end else begin
//                next = counter + 1;
//                clk_out = 0;
//            end
//        end

            if (counter == toggle_value - 1) begin
//                next = 0;
                clk_out <= ~clk_out;
                counter <= 0;
            end else begin
//                next = counter + 1;
//                clk_out = 0;
                counter <= counter + 1;
            end
        end
        
    end
    
endmodule























