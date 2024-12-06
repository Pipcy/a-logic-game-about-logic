`timescale 1ns / 1ps

/*
 * This clock divider slows the clock from the FPGA's built-in 100 MHz to
 * a baud rate of 9600 to facilitate UART communication.
 */

module baud_clk_divider(
    input clk_in,
    input rst,
    output clk_out
    );
    
    // To achieve a baud rate of 9600, we need to divide the clock by a factor of:
    // 100,000,000 / 9,600 = 10,416
    parameter toggle_value = 10416;

    reg [31:0] counter;
    wire [31:0] next;

    always @(posedge clk_in or posedge rst) begin
        if (rst) counter <=0;
        else counter <= next;

        if (counter == toggle_value)
            assign next = 0;
            assign clk_out = 1;
        else
            next = counter + 1;
            assign clk_out = 0;
    end
    
endmodule












