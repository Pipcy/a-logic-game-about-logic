`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2024 12:07:47 PM
// Design Name: 
// Module Name: Player_controller_Work
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


module Player_controller_Work(
 input rst,                  // reset
    input clk,                  // clock
    input button_up,            // move upwards
    input button_down,          // move downwards
    input is_firing,            // fire a projectile
    input projectile,           // switch projectile type
    output reg [7:0] data_out   // 8-bit encoded data to be sent via UART
    );   
    
    // Registers for the current and next state (lane)
    reg [3:0] current_state;
//    reg [3:0] next_state;
    reg [1:0] projectile_encoded;
    wire clean_button_up;
    wire clean_button_down;
    wire clean_is_firing;
    wire clean_rst;
    wire cleanbuttonup;
    wire cleanbuttondown;
    wire cleanisfiring;
    wire cleanrst;

    // Instantiate a debouncer for each button input    
    debouncer d1(clk, button_up, clean_button_up, cleanbuttonup);
    debouncer d2(clk, button_down, clean_button_down, cleanbuttondown);
    debouncer d3(clk, is_firing, clean_is_firing, cleanisfiring);
    debouncer d4(clk, rst, clean_rst, cleanrst);
    // TODO: reset?!
    
    // STATE DEFINITIONS
    localparam  RESET = 4'b0000,
                LANE1 = 4'b0001,
                LANE2 = 4'b0010,
                LANE3 = 4'b0011,
                LANE4 = 4'b0100,
                LANE5 = 4'b0101,
                LANE6 = 4'b0110;
                
    
    // INITIALIZATION
//    initial begin
//        // Start in the reset state, vertically centered
//        current_state = RESET;
//        next_state = current_state;
//        data_out = 8'b00000000;
//        projectile_encoded = 2'b00;
//    end
    initial begin 
    projectile_encoded = 2'b00;
    end
    // STATE MACHINE
    always @(negedge clk or posedge clean_rst) begin 
    if (clean_rst) begin 
    current_state = RESET;
    projectile_encoded <= 2'b00;
    end else begin 
    
    case (current_state)
    RESET: current_state <= LANE3;
    
    LANE1: begin 
    if( cleanbuttonup) current_state <= LANE2;
    end
    
    LANE2: begin
    if(cleanbuttonup) current_state <= LANE3; 
        else if(cleanbuttondown) current_state <= LANE1; 
        end
        
   LANE3: begin 
   if(cleanbuttonup) current_state <= LANE4; 
    else if(cleanbuttondown) current_state <= LANE2; 
    end
    
   LANE4: begin 
   if(cleanbuttonup) current_state <= LANE5; 
    else if(cleanbuttondown) current_state <= LANE3; 
    end
    
    LANE5: begin 
    if(cleanbuttonup) current_state <= LANE6; 
    else if(cleanbuttondown) current_state <= LANE4; 
    end
    
    LANE6: begin
    if(cleanbuttondown) current_state <= LANE5; 
    end 
    
    default: current_state <= LANE3;
    endcase 
    
    if(clean_is_firing) projectile_encoded[1] <= 1'b1;
    else projectile_encoded[1] = 1'b0;
    if(projectile) projectile_encoded[0] <= 1'b1;
    else  projectile_encoded[0] <= 1'b0;
  end
        end
    always @(*) begin 
    data_out = {rst, 1'b0, projectile_encoded, current_state};
    end 
    
endmodule
