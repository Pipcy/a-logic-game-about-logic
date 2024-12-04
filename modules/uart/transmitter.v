`timescale 1ns / 1 ps

module transmitter(
  input clk_in,
  input clk_baud,
  input rst,
  input start,
  input [7:0] data_out,
  output tx_out
);
  reg tx, next_tx;
  reg [1:0] state, next_state;
  reg [3:0] baud_count, next_baud_count;
  reg [2:0] index, next_index;
  reg [7:0] data, next_data;

  // States
  localparam [1:0] IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;

  // Reset, or on posedge of clock, update our registers to the next value
  always @(posedge clk_in or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      baud_count <= 0;
      index <= 0;
      data <= 0;
      tx <= 1;
    end
    else begin
      state <= next_state;
      baud_count <= next_baud_count;
      index <= next_index;
      data <= next_data;
      tx <= next_tx;
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
        tx_next = 1; // idle bit
        // If start bit is high
        if (start) begin
          next_state = START;
          next_baud_count = 0;
          next_index = 0;
        end
      end
      
      START : begin
        tx_next = 0; // start bit
        // check baud
        if (clk_baud) begin
          if (baud_count == 15) begin // 16 oversampling ticks per bit
            // ready to send the data
            next_state = DATA;
            baud_count_next = 0;
            index_next = 0;
          end
          // otherwise incremement the count
          else baud_count_next = baud_count + 1;
        end
      end
      
      DATA : begin
        // actually send the LSB of the data
        tx_next = data[0];
        // check baud
        if (clk_baud) begin
          if (baud_count == 15) begin
            // reset the count and shift the data
            baud_count_next = 0;
            data_next = data >> 1;
            // increment index, or stop if we're at the end
            if (index == 7)
              next_state = STOP;
            else
              index_next = index + 1;
          end
          else // if baud_count is not yet 15
            baud_count_next = baud_count + 1;
        end
      end
      
      STOP : begin
        next_tx = 1;
        if (baud_clk) begin
          // stop bit goes for 16 ticks
          if (baud_count == 15)
            // then go back to idle
            next_state = IDLE;
        end
      end
      
    endcase

    // actual bit to be transmitted
    assign tx_out = tx;
  end
  
endmodule
