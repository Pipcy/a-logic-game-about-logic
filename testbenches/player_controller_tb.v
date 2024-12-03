`timescale 1ns / 1ps

module player_controller_tb(
    );
    
    reg rst, clk, button_up, button_down, is_firing, projectile;
    wire [7:0] data_out;
    
    player_controller pc(rst, clk, button_up, button_down, is_firing, projectile, data_out);
    // TODO: add debouncer module
    
    initial begin
        rst = 0; clk = 0; button_up = 0; button_down = 0; is_firing = 0; projectile = 0;
        #2 // TODO: test various inputs
        
        // press up button a few times
        #2 button_up = 1;
        #6 button_up = 0;
        #6 button_up = 1;
        #6 button_up = 0;
        
        #50 $finish;
    
    end
    
    // Every 5, toggle the clock
    always #5 clk = ~clk;
    // Every 2, print our output
    //alawys #2 $display("data_out = %b", data_out);
    
endmodule









