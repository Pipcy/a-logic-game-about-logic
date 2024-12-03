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
    end
    
    // STATE MACHINE
    
    // At posedge of clk or either button, update our movement
    always @(posedge clk or posedge button_up or posedge button_down) begin
        // TODO: update encoded data each clock cycle (projectile check)
        // (for now just set data_out equal to our current state)
        data_out <= {4'b0, next_state};
        
        // TODO: determine next state (movement check)
        current_state <= next_state;
        case (current_state)
            
            RESET : begin
                // Start in the center lane (5)
                next_state = LANE5;
            end
            
            LANE1 : begin
                // Can only move upwards
                if (button_up) begin
                    
                end
            end
            
            LANE2 : begin
            end
            
            LANE3 : begin
            end
            
            LANE4 : begin
            end
            
            LANE5 : begin
            end
            
            LANE6 : begin
            end
            
            LANE7 : begin
            end
            
            LANE8 : begin
            end
            
            LANE9 : begin
                // Can only move downwards
            end
        
        
        
        endcase
    
    
    
    
    
    end
    
    
endmodule









