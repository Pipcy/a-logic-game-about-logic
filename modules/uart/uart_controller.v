`timescale 1ns / 1ps

/*
 * This is the real top module!
 * The uart_controller module brings together the other uart modules.
 * It transmits our 8-bit output (from player_controller) to the host machine.
 *
 */

module uart_controller(
	input clk_in, 	// 100 MHz
	input rst, 		// player input (button)
	input up, 		// player input (button)
	input down,		// player input (button)
	input fire,		// player input (button)
	input proj,		// player input (switch)
	output tx		// transmission bit
);
	
	wire [7:0] data_out; 	// data_out is provided by the player_controller module
	wire clk_baud;
	wire good2go;
	assign good2go = 1;

	// Instantiate clock divider for baud rate
	baud_clk_divider BCD(
		.clk_in(clk_in),
		.rst(rst),
		.clk_out(clk_baud)
	);

	// Instantiate player_controller to get output data (data_out)
	player_controller PC(
		.rst(rst),
		.clk(clk_in),
		.button_up(up),
		.button_down(down),
		.is_firing(fire),
		.projectile(proj),
		.data_out(data_out)
	);
    // Temporarily just send 00000011
//    assign data_out = 8'b00000011;

	// Instantiate transmitter module and pass data_out to it
	transmitter TX(
		.clk_in(clk_in),
		.clk_baud(clk_baud),
		.rst(rst),
		.start(good2go),
		.data_out(data_out),
		.tx_out(tx)
	);

endmodule
