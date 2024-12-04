`timescale 1ns / 1ps

module uart_test(
    input clk_100MHz,       // basys 3 FPGA clock signal
    input reset,            // btnR    
    input rx,               // USB-RS232 Rx
    input btn_0,      
    input btn_1,
    input btn_2,
    input btn_3,      
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

    // Signal Logic    
    assign rec_data1 = {btn_tick_0, btn_tick_1, btn_tick_2, btn_tick_3, 4'b1111};
    
    // Output Logic
    assign LED = rec_data;              // data byte received displayed on LEDs
    assign an = 4'b1110;                // using only one 7 segment digit 
    assign seg = {~rx_full, 2'b11, ~rx_empty, 3'b111};
endmodule