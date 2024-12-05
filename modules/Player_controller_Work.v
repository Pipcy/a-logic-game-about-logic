`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 03:16:56 PM
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
    wire clean_projectile;

    // Instantiate a debouncer for each button input    
    debouncer_1 d1(clk, button_up, clean_button_up);
    debouncer_1 d2(clk, button_down, clean_button_down);
    debouncer_1 d3(clk, is_firing, clean_is_firing);
    debouncer_1 d4(clk, projectile, clean_projectile);
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
    always @(posedge clk or posedge rst) begin 
    if (rst) begin 
    current_state = RESET;
    projectile_encoded <= 2'b00;
    end else begin 
    case (current_state)
    RESET: current_state <= LANE3;
    
    LANE1: begin 
    if(clean_button_up) current_state <= LANE2;
    end
    
    LANE2: begin
    if(clean_button_up) current_state <= LANE3; 
        else if(clean_button_down) current_state <= LANE1; 
        end
        
   LANE3: begin 
   if(clean_button_up) current_state <= LANE4; 
    else if(clean_button_down) current_state <= LANE2; 
    end
    
   LANE4: begin 
   if(clean_button_up) current_state <= LANE5; 
    else if(clean_button_down) current_state <= LANE3; 
    end
    
    LANE5: begin 
    if(clean_button_up) current_state <= LANE6; 
    else if(clean_button_down) current_state <= LANE4; 
    end
    
    LANE6: begin
    if(clean_button_down) current_state <= LANE5; 
    end 
    
    default: current_state <= LANE3;
    endcase 
    
    if(clean_is_firing) projectile_encoded[1] <= 1'b1;
    else projectile_encoded[1] = 1'b0;
    if(clean_projectile) projectile_encoded[0] <= ~projectile_encoded[0];
  end
        end
    always @(*) begin 
    data_out = {rst, 1'b0, projectile_encoded, current_state};
    end 
    
   
    // At posedge of buttons, update our movement
//    always @(posedge clean_button_up) begin
//        // as long as we are not at lane, move up one lane
//        if (~(current_state == LANE6)) begin
//            next_state = current_state + 4'b0001; 
//        end
//    end
//    always @(posedge clean_button_down) begin
//        // as long as we are not at lane1, move down one lane
//        if (~(current_state == LANE1)) begin //
//            next_state = current_state - 4'b0001;
//        end
//    end
//    // At posedge of rst, reset the game (asynchronous)
//    always @(posedge rst) begin
//        next_state = RESET;
//        current_state = RESET;
//        data_out = 8'b00000000;
//        projectile_encoded = 2'b00;
//    end
    
//    //  Update current state and encode output data
//    always @(*) begin //
//        if (current_state == RESET) begin
//            next_state <= LANE3;
//        end
        
//        // Move to the next state
//        current_state = next_state;

//        // Encode projectile data in two bits
//        projectile_encoded[1] = clean_is_firing;
//        projectile_encoded[0] = clean_projectile;
//        // Encode output data: rst, (nothing/0), projectile, and lane
//        data_out <= {rst, 1'b0, projectile_encoded, current_state}; 
        
        endmodule 
