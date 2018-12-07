`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    12:36:00 02/18/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    Serial_UART_Transmitter
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v15.0
// Description:    Serial UART Transmitter Module
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module Serial_UART_Transmitter
#(
	parameter DATA_BITS = 8,
	parameter STOP_BITS = 1
)
(
	// UART Transmitter Signals
	input                      TX_SEND,
	input      [DATA_BITS-1:0] TX_DATA,
	output reg                 TX_DONE,

	// UART Bus Signals
	output reg  UART_TX,
	
	// Baud Clock Signals
	input BAUD_TICK,
	
	// System Signals
	input CLK,
	input RESET
);	

	// Include Standard Functions header file (needed for bit_index())
	`include "StdFunctions.vh"

	
	//
	// Compute the Packet and Bit Counter Widths
	//
	localparam START_BITS = 1;  // Always One Start Bit
	localparam PARITY_BITS = 0; // No Parity Bit Support (yet)
	
	localparam FRAME_BITS = START_BITS + DATA_BITS + PARITY_BITS + STOP_BITS;
	
	// Remove the Stop Bits from the Frame Register width because
	// the Stop Bits will be implicity set by filling the shift
	// register with 1's so any number of Stop Bits can be output
	// without adding more registers.
	localparam FRAME_WIDTH = FRAME_BITS - STOP_BITS;
	
	localparam BIT_COUNT_WIDTH = bit_index(FRAME_BITS);
	localparam [BIT_COUNT_WIDTH:0] BIT_COUNT_LOADVAL = {1'b1, {BIT_COUNT_WIDTH{1'b0}}} - FRAME_BITS[BIT_COUNT_WIDTH:0];

	reg    [FRAME_WIDTH-1:0] tx_frame_data_reg;
	reg  [BIT_COUNT_WIDTH:0] tx_bit_counter;
	
	wire tx_bit_counter_done = tx_bit_counter[BIT_COUNT_WIDTH];
	
	
	//
	// Serial UART Transmitter State Machine
	//

	// !! Lab 5: Add the Serial UART Transmitter State Machine here !!

endmodule
