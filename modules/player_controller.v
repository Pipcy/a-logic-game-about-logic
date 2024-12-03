`timescale 1ns / 1ps

/*
 * The player_controller is the top module that handles user input, including
 * vertical movement, firing projectiles, switching projectile types, and reset.
 * It outputs the player position (in the form of a lane number), projectile
 * information, reset and clock values. These outputs are encoded to fit
 * in a single 8-bit number, data_out.
 *
 */

module player_controller(
    input rst,                  // reset
    input clk,                  // clock
    input button_up,            // move upwards
    input button_down,          // move downwards
    input is_firing,            // fire a projectile
    input projectile,           // switch projectile type
    output reg [7:0] data_out   // 8-bit encoded data to be sent via UART
    );   
     
    // CONFIGURATION
    localparam SCREEN_HEIGHT = 640;
    localparam NUMBER_OF_LANES = 9;
    localparam LANE_SIZE = SCREEN_HEIGHT / NUMBER_OF_LANES;
    
    // Registers for the current and next state (lane)
    reg [3:0] current_state;
    reg [3:0] next_state;
    reg [1:0] projectile_encoded;
    
    // STATE DEFINITIONS
    localparam  RESET = 4'b0000,
                LANE1 = 4'b0001,
                LANE2 = 4'b0010,
                LANE3 = 4'b0011,
                LANE4 = 4'b0100,
                LANE5 = 4'b0101,
                LANE6 = 4'b0110,
                LANE7 = 4'b0111,
                LANE8 = 4'b1000,
                LANE9 = 4'b1001;
    
    // INITIALIZATION
    initial begin
        // Start in the reset state, vertically centered
        current_state = RESET;
        next_state = current_state;
        data_out = 8'b00000000;
        projectile_encoded = 2'b00;
    end
    
    // STATE MACHINE
    
    // At posedge of buttons, update our movement
    always @(posedge button_up) begin
        // as long as we are not at lane9, move up one lane
        if (~(current_state == LANE9)) begin
            next_state = current_state + 8'b00000001;
        end
    end
    always @(posedge button_down) begin
        // as long as we are not at lane1, move down one lane
        if (~(current_state == LANE9)) begin
            next_state = current_state - 8'b00000001;
        end
    end
    // At posedge of rst, reset the game (asynchronous)
    always @(posedge rst) begin
        next_state = RESET;
        current_state = RESET;
        data_out = 8'b00000000;
        projectile_encoded = 2'b00;
    end
    
    // At posedge of clk, update current state and encode output data
    always @(posedge clk) begin
        if (current_state == RESET) begin
            current_state <= LANE5;
        end
        
        // Move to the next state
        current_state <= next_state;

        // Encode projectile data in two bits
        projectile_encoded[1] = is_firing;
        projectile_encoded[0] = projectile;
        // Encode output data: rst, (nothing/0), projectile, and lane
        data_out <= {rst, 0, projectile_encoded, next_state};
        
        
        
        // CASE STATEMENT this is all useless? to delete later
//        case (current_state)
            
//            RESET : begin
//                // Start in the center lane (5)
//                next_state = LANE5;
//            end
            
//            LANE1 : begin
//                // Can only move upwards
//                if (button_up) begin
                    
//                end
//            end
            
//            LANE2 : begin
//            end
            
//            LANE3 : begin
//            end
            
//            LANE4 : begin
//            end
            
//            LANE5 : begin
//            end
            
//            LANE6 : begin
//            end
            
//            LANE7 : begin
//            end
            
//            LANE8 : begin
//            end
            
//            LANE9 : begin
//                // Can only move downwards
//            end
        
//        endcase
    
    
    
    
    
    end
    
    
endmodule









