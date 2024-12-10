`timescale 1ns / 1ps

module transmitter(
  input clk_in,
  input clk_baud,
  input rst,
  input start,
  input [7:0] data_out,
  output reg tx_out
);
  reg tx, next_tx;
  reg [1:0] state, next_state;
  reg [3:0] baud_count, next_baud_count;
  reg [2:0] index, next_index;
  reg [7:0] data, next_data;
//  reg baud_count_updated;

  // States
  localparam [1:0] IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;

  // Reset, or on posedge of clock, update our registers to the next value
  always @(posedge clk_in or posedge rst) begin
    if (rst) begin
      state <= IDLE;
      baud_count <= 0;
      index <= 0;
//      data <= 0;
      data <= data_out;
      tx <= 1;
//      baud_count_updated <= 0;
    end
    else begin
      state <= next_state;
      baud_count <= next_baud_count;
      index <= next_index;
      data <= next_data;
      tx <= next_tx;
//      if (baud_count_updated) baud_count_updated <= 0;
    end
  end

  // FSM to continuously update states
  always @(*) begin

    // by default next is same as previous
    next_state = state;
    next_baud_count = baud_count;
    next_index = index;
    next_data = data;
    next_tx = tx;

    case(state)
      IDLE : begin
        next_tx = 1; // idle bit
        // If start bit is high
        if (start) begin
          next_state = START;
          next_baud_count = 0;
          next_index = 0;
        end
      end
      
      START : begin
        next_tx = 0; // start bit
        // check baud
        if (clk_baud) begin
          if (baud_count == 15) begin // 16 oversampling ticks per bit
            // ready to send the data
            next_state = DATA;
            next_baud_count = 0;
            next_index = 0;
          end
          // otherwise incremement the count
          else begin
            next_baud_count = baud_count + 1;
          end
        end
      end
      
      DATA : begin
        // actually send the LSB of the data
        next_tx = data[0];
        // check baud
        if (clk_baud) begin
          if (baud_count == 15) begin
            // reset the count and shift the data
            next_baud_count = 0;
            next_data = data >> 1;
            // increment index, or stop if we're at the end
            if (index == 7)
              next_state = STOP;
            else
              next_index = index + 1;
          end
          else begin // if baud_count is not yet 15
            next_baud_count = baud_count + 1;
          end
        end
      end
      
      STOP : begin
        next_tx = 1;
        if (clk_baud) begin
          // stop bit goes for 16 ticks
          if (baud_count == 15)
            // then go back to idle
            next_state = IDLE;
        end
      end
      
    endcase

    // actual bit to be transmitted
    tx_out = tx;
  end
  
endmodule
