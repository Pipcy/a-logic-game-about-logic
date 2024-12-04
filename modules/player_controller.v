`timescale 1ns / 1ps

/*
 * This is no longer the topmost module!
 *
 * The player_controller (instantiated by uart_controller) handles user input, including
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
    
    // Registers for the current and next state (lane)
    reg [3:0] current_state;
    reg [3:0] next_state;
    reg [1:0] projectile_encoded;
    wire clean_button_up;
    wire clean_button_down;
    wire clean_is_firing;
    wire clean_projectile;

    // Instantiate a debouncer for each button input    
    debouncer d1(clk, button_up, clean_button_up);
    debouncer d2(clk, button_down, clean_button_down);
    debouncer d3(clk, is_firing, clean_is_firing);
    debouncer d4(clk, projectile, clean_projectile);
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
    initial begin
        // Start in the reset state, vertically centered
        current_state = RESET;
        next_state = current_state;
        data_out = 8'b00000000;
        projectile_encoded = 2'b00;
    end
    
    // STATE MACHINE
    
    // At posedge of buttons, update our movement
    always @(posedge clean_button_up) begin
        // as long as we are not at lane, move up one lane
        if (~(current_state == LANE6)) begin
            next_state = current_state + 4'b0001; 
        end
    end
    always @(posedge clean_button_down) begin
        // as long as we are not at lane1, move down one lane
        if (~(current_state == LANE1)) begin //
            next_state = current_state - 4'b0001;
        end
    end
    // At posedge of rst, reset the game (asynchronous)
    always @(posedge rst) begin
        next_state = RESET;
        current_state = RESET;
        data_out = 8'b00000000;
        projectile_encoded = 2'b00;
    end
    
    //  Update current state and encode output data
    always @(*) begin //
        if (current_state == RESET) begin
            next_state <= LANE3;
        end
        
        // Move to the next state
        current_state = next_state;

        // Encode projectile data in two bits
        projectile_encoded[1] = clean_is_firing;
        projectile_encoded[0] = clean_projectile;
        // Encode output data: rst, (nothing/0), projectile, and lane
        data_out <= {rst, 1'b0, projectile_encoded, current_state}; 
        
    end
    
    
endmodule









  
