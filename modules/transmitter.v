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
  reg [3:0] baud, next_baud;
  reg [2:0] index, next_index;
  reg [7:0] data, next_data;
  parameter STOP_BIT_TICKS = 16;

  // States
  localparam [1:0] IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;

  // Reset, or on posedge of clock, update our registers to the next value
  always @(posedge clk_in or posedge reset) begin
    if (reset) begin
      state <= IDLE;
      baud <= 0;
      index <= 0;
      data <= 0;
      tx <= 1;
    end
    else begin
      state <= next_state;
      baud <= next_baud;
      index <= next_index;
      data <= next_data;
      tx <= next_tx;
    end
  end
