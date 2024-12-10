`timescale 1ns / 1ps


module uart_controller_tb(
    );
    
    reg rst, clk, button_up, button_down, is_firing, projectile;
    wire tx;
    
	uart_controller UC(
		.clk_in(clk),
		.rst(rst),
		.up(button_up),
		.down(button_down),
		.fire(is_firing),
		.proj(projectile),
		.tx(tx)
  );
    
    initial begin
        rst = 0; clk = 0; button_up = 0; button_down = 0; is_firing = 0; projectile = 0;
        #12 rst = 1;
        #12 rst = 0;
        #12 button_up = 1;
        #16 button_up = 0;

        #2000 $finish;
    
    end
    
    // Every 5, toggle the clock
    always #5 clk = ~clk;
    
endmodule
