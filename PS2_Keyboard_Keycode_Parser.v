`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    23:54:00 02/04/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    PS2_Keyboard_Keycode_Parser
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v15.0
// Description:    PS/2 Keyboard Keycode Parser
//                 This module will process the raw keyboard data to report
//                 full key presses.
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module PS2_Keyboard_Keycode_Parser
(
	// PS/2 Key Code Input Signals
	input            KEY_READY,
	input      [7:0] KEY_DATA,
	
	// Key Pressed Status Signals
	output reg       KEY_PRESSED_MAKE,
	output reg       KEY_PRESSED_BREAK,
	output reg [7:0] KEY_PRESSED_DATA,
	
	// System Signals
	input CLK,
	input RESET
);
		
	
	// Key Modifier Status Flags
	reg key_release_flag;  // Release Key Code Received (0xF0)
//	reg key_extended_flag;  // Extended Key Code Received (0xE0)
	
	
	//
	// Check Key Code for Modifier Status Flags
	//   Note: This removes the 8-bit wide mux propagation
	//         delay from the state machine timing.
	//
	reg [1:0] status_flag;
	
	always @(posedge CLK)
	begin
		case (KEY_DATA)
			8'hE0   : status_flag <= 2'h1;
			8'hF0   : status_flag <= 2'h2;
			default : status_flag <= 2'h0;
		endcase
	end
	
	
	//
	// PS/2 Serial Controller State Machine
	//

	// !! Lab 5: Add the PS2 Keyboard Keycode Parser State Machine here !!
	
endmodule
