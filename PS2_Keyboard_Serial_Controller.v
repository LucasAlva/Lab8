`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    23:54:00 02/04/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    PS2_Keyboard_Serial_Controller
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v15.0
// Description:    PS/2 Keyboard Serial Controller
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module PS2_Keyboard_Serial_Controller
(
	// PS/2 Bus Signals (Synchronized to CLK)
	input  PS2_CLK_SYNC,
	input  PS2_DATA_SYNC,

	// PS/2 Serial Interface Signal
	output reg       PS2_KEY_READY,
	output reg [7:0] PS2_KEY_DATA,
	
	// System Signals
	input CLK,
	input RESET
);
	
	// Include StdFunctions for bit_index()
	`include "StdFunctions.vh"
	

	//
	// Compute Bit Count parameters
	//
	localparam BIT_COUNT_BITS = 10; // { 1 stop-bit, 1 parity-bit, 8 data-bits }
	localparam BIT_COUNT_WIDTH = bit_index(BIT_COUNT_BITS);
	localparam BIT_COUNT_LOADVAL = {1'b1, {BIT_COUNT_WIDTH{1'b0}}} - BIT_COUNT_BITS[BIT_COUNT_WIDTH-1:0];

	
	//
	// Parity Calculation
	//
	// The keyboard calculates Odd Parity by xor'ing each data bit:
	//
	//   parity_bit = d0 ^ d1 ^ d2 ^ d3 ^ d4 ^ d5 ^ d6 ^ d7
	//
	// This controller validates the received data's parity by xor'ing the 
	//   incoming data bits along with the incoming parity bit which 
	//   results in a matching status indicator, parity_good.
	//
	//   parity_good = (d0 ^ d1 ^ d2 ^ d3 ^ d4 ^ d5 ^ d6 ^ d7) ^ parity_bit
	//
	// Additionally, an optimization to reduce FSM logic was implemented that
	//   also xor's the stop-bit into the parity calculation. To compensate
	//   for the stop-bit's always 1 value, the initial value of parity_good
	//   was also set to 1 which negates the stop-bit.
	//
	// The final parity check equation used by this controller is:
	//
	//   ps2_parity_good = 1 ^ (^ps2_data_reg ^ parity_bit) ^ stop_bit
	//	
	// The ps2_parity_good signal will be high if the calculated parity 
	//   matches the transmitted parity, and low if not.
	//
	reg  ps2_parity_good;

	
	//
	// PS/2 Clock Falling-Edge Detector
	//
	wire ps2_clk_negedge;
	reg  ps2_clk_reg;

	initial
	begin
		ps2_clk_reg <= 1'b0;
	end
	
	// Clock Previous-Edge Register
	always @(posedge CLK)
	begin
		ps2_clk_reg <= PS2_CLK_SYNC;
	end

	// Detect a falling-edge by looking for a high to low transition by
	//   comparing the Previous-Edge register to the current clock signal.
	assign ps2_clk_negedge = ps2_clk_reg & ~PS2_CLK_SYNC;

	
	//
	// PS/2 Serial Controller State Machine
	//
	reg  [BIT_COUNT_WIDTH:0]  bit_count_reg;
	wire                      bit_count_done = bit_count_reg[BIT_COUNT_WIDTH];
	
	reg  [BIT_COUNT_BITS-1:0] ps2_data_reg; // { 1 stop-bit, 1 parity-bit, 8 data-bits }
	
	wire                      ps2_start_bit;
	wire                      ps2_stop_bit;
	
	// Start Bit happens on the falling clock edge when the Data line is low
	assign ps2_start_bit = ps2_clk_negedge & ~PS2_DATA_SYNC;
	
	// Stop Bit is the MSB of the data register
	assign ps2_stop_bit = ps2_data_reg[BIT_COUNT_BITS-1];
	
	
	// !! Lab 5: Add the PS2 Keyboard Serial Controller State Machine here !!

endmodule
