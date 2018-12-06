`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    23:54:00 02/04/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    PS2_Keyboard_Module
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v17.0
// Description:    PS/2 Keyboard Interface Module
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module PS2_Keyboard_Module
#(
	parameter CLK_RATE_HZ = 50000000 // Hz
)
(
	// PS/2 Bus Signals
	input  PS2_CLK,
	input  PS2_DATA,
	
	// Key Pressed Status Signals
	output        KEY_PRESSED,
	output  [7:0] KEY_KEYCODE,
	output  [7:0] KEY_KEYCHAR,
	
	// PS/2 Bus Monitor Signals
	output        PS2_CLK_MONITOR,
	output        PS2_DATA_MONITOR,
	output  [7:0] PS2_KEYCODE_MONITOR,
	
	// System Signals
	input  CLK,
	input  RESET
);
	
	//
	// PS/2 Bus Signal Synchronization
	//
	wire ps2_clk_sync;
	wire ps2_data_sync;
	
	PS2_Bus_Synchronizer
	#(
		.CLK_RATE_HZ( CLK_RATE_HZ ),
		.MIN_PULSE_TIME( 5000 ) // 5us min pulse
	)
	PS2_Bus_Sync
	(
		// PS/2 Bus Input Signals (asynchronous)
		.PS2_CLK_IN( PS2_CLK ),
		.PS2_DATA_IN( PS2_DATA ),
		
		// PS/2 Bus Output Signals (synchronized CLK domain)
		.PS2_CLK_OUT( ps2_clk_sync ),
		.PS2_DATA_OUT( ps2_data_sync ),
		
		// System Signals
		.CLK( CLK )
	);

	//
	// PS/2 Keyboard Serial Controller
	//
	wire       ps2_key_ready;
	wire [7:0] ps2_key_data;

	PS2_Keyboard_Serial_Controller kb_serial_controller
	(
		// PS/2 Bus Signals (Synchronized to CLK)
		.PS2_CLK_SYNC( ps2_clk_sync ),
		.PS2_DATA_SYNC( ps2_data_sync ),

		// PS/2 Serial Interface Signal
		.PS2_KEY_READY( ps2_key_ready ),
		.PS2_KEY_DATA( ps2_key_data ),
		
		// System Signals
		.CLK( CLK ),
		.RESET( RESET )
	);


	//
	// PS/2 Keyboard Keycode Parser
	//
	wire       key_make;
	wire       key_break;
	wire [7:0] key_data;
	
	PS2_Keyboard_Keycode_Parser kb_keycode_parser
	(
		// PS/2 Key Code Input Signals
		.KEY_READY( ps2_key_ready ),
		.KEY_DATA( ps2_key_data ),
		
		// Key Pressed Status Signals
		.KEY_PRESSED_MAKE( key_make ),
		.KEY_PRESSED_BREAK( key_break ),
		.KEY_PRESSED_DATA( key_data ),
		
		// System Signals
		.CLK( CLK ),
		.RESET( RESET )
	);

	
	//
	// PS/2 Keyboard Keypress Tracker
	//
	PS2_Keyboard_Keypress_Tracker kb_keypress_tracker
	(
		// PS/2 Key Press Signals
		.KEY_MAKE( key_make ),
		.KEY_BREAK( key_break ),
		.KEY_DATA( key_data ),

		// Key Pressed Status Signals
		.KEY_PRESSED( KEY_PRESSED ),
		.KEY_KEYCODE( KEY_KEYCODE ),
		.KEY_KEYCHAR( KEY_KEYCHAR ),
		
		// System Signals
		.CLK( CLK ),
		.RESET( RESET )
	);

	
	//
	// PS/2 Bus Monitors (Debug Outputs for Logic Analyzer Monitoring)
	//
	assign PS2_CLK_MONITOR = ps2_clk_sync;
	assign PS2_DATA_MONITOR = ps2_data_sync;
	assign PS2_KEYCODE_MONITOR = ps2_key_data;

endmodule
