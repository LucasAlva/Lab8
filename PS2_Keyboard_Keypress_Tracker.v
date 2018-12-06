`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    13:09:00 08/14/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    PS2_Keyboard_Keypress_Tracker
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v17.0
// Description:    PS/2 Keyboard Keypress Tracker
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module PS2_Keyboard_Keypress_Tracker
(
	// PS/2 Key Press Signals
	input        KEY_MAKE,
	input        KEY_BREAK,
	input  [7:0] KEY_DATA,

	// Key Pressed Status Signals
	output reg       KEY_PRESSED,
	output reg [7:0] KEY_KEYCODE,
	output reg [7:0] KEY_KEYCHAR,
	
	// System Signals
	input CLK,
	input RESET
);


	//
	// Keycode Transcoder
	//
	reg  [7:0] key_keycode_reg;
	wire [7:0] key_keychar_reg;
	
	PS2_Keycode_Transcoder keycode_transcoder
	(
		// Input Signals
		.KEY_CODE( key_keycode_reg ),
		
		// Output Signals
		.KEY_CHAR( key_keychar_reg ),
		
		// System Signals
		.CLK( CLK )
	);


	//
	// Keypress Tracker State Machine
	//

	// !! Lab 5: Add the PS2 Keyboard Keypress Tracker State Machine here !!

endmodule
