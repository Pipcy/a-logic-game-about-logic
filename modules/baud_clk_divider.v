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
    // 100,000,000 / 9,600 = 10,417
    
    
    
    
    
endmodule












