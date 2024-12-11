`timescale 1ns / 1ps

module uart_test(
    input clk_100MHz,       // basys 3 FPGA clock signal
    input reset,            // btnR    
    input rx,               // USB-RS232 Rx
    input btn_0,      
    input btn_1,
    input btn_2,
    input btn_3, 
    input proj,     
    output tx,              // USB-RS232 Tx
    output [3:0] an,        // 7 segment display digits
    output [0:6] seg,       // 7 segment display segments
    output [7:0] LED        // data byte display
    );
    
    // Connection Signals
    wire rx_full, rx_empty, btn_tick_0, btn_tick_1, btn_tick_2, btn_tick_3, btn_send;
    wire [7:0] rec_data, rec_data1;
    
    // Complete UART Core
    uart_top UART_UNIT
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .read_uart(btn_send),
            .write_uart(btn_send),
            .rx(rx),
            .write_data(rec_data1),
            .rx_full(rx_full),
            .rx_empty(rx_empty),
            .read_data(rec_data),
            .tx(tx)
        );

/////////////////////////////////////////////////
// Debouncers -- only button changes send updates
/////////////////////////////////////////////////

    // Button Debouncers
    debounce_explicit BUTTON_DEBOUNCER1
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .btn(btn_0),         
            .db_level(),  
            .db_tick(btn_tick_0)
        );

    debounce_explicit BUTTON_DEBOUNCER2
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .btn(btn_1),         
            .db_level(),  
            .db_tick(btn_tick_1)
        );
    
    debounce_explicit BUTTON_DEBOUNCER3
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .btn(btn_2),         
            .db_level(),  
            .db_tick(btn_tick_2)
        );

    debounce_explicit BUTTON_DEBOUNCER4
        (
            .clk_100MHz(clk_100MHz),
            .reset(reset),
            .btn(btn_3),         
            .db_level(),  
            .db_tick(btn_tick_3)
        );

    assign btn_send = btn_tick_0 | btn_tick_1 | btn_tick_2 | btn_tick_3;


//    assign rec_data1 = {btn_tick_0, btn_tick_1, btn_tick_2, btn_tick_3, 4'b1111};
    
//    assign rec_data1 = {4'b0011, 1'b0, 1'b0, btn_tick_2 | btn_tick_3, btn_tick_1 | btn_tick_3 };
//        assign rec_data1 = (btn_tick_0) ? 8'b00110000 :   // '0' (0x30)
//                   (btn_tick_1) ? 8'b00110001 :   // '1' (0x31)
//                   (btn_tick_2) ? 8'b00110010 :   // '2' (0x32)
//                   (btn_tick_3) ? 8'b00110011 :   // '3' (0x33)
//                   8'b00100000;  // Default case (just in case)        
    pc PLAYER(
        .rst(reset),
        .clk(clk_100MHz),
        .button_up(btn_3),
        .button_down(btn_0),
        .is_firing(btn_2),
        .projectile(proj),
        .data_out(rec_data1)
        );

    
    // Output Logic
    assign LED = rec_data1;              // data byte received displayed on LEDs
    assign an = 4'b1110;                // using only one 7 segment digit 
    assign seg = {~rx_full, 2'b11, ~rx_empty, 3'b111};
endmodule