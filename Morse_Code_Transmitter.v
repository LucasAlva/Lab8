`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    22:23:00 01/17/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    Morse_Code_Transmitter
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v17.0
// Description:    Morse Code Transmitter
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module Morse_Code_Transmitter
(
	// Input Signals
	input        SEND,
	input [12:0] SEQ_DATA,
	input  [3:0] SEQ_LEN,
	input        RATE_TICK,
	
	// Output Signals
	output reg  DONE,
	output reg  MC_OUT,
	
	// System Signals
	input CLK,
	input RESET
);

	//
	// Transmitter State Machine
	//
	reg  [4:0] bit_count_reg;
	reg [12:0] bit_shift_reg;
	
	wire       bit_count_done = bit_count_reg[4];
	
	// !! Lab 5: Add the Morse Code Transmitter State Machine here !!

endmodule
