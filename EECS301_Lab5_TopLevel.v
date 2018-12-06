`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    16:00:00 09/17/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    EECS301_Lab5_TopLevel
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v17.0
// Description:    EECS301 Lab 5 Top Level File
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module EECS301_Lab5_TopLevel
(
	// Clock Signals
	input         CLOCK_50,

	// 7-Segment Display Signals (Active-Low)
	output  [6:0] HEX0,
	output  [6:0] HEX1,
	output  [6:0] HEX2,
	output  [6:0] HEX3,
	output  [6:0] HEX4,
	output  [6:0] HEX5,
	
	// LED Status Signals
	output  [9:0] LEDR,
	
	// Switch Input Signals
	input   [1:0] SW,
	
	// PS/2 Keyboard Port Signals
	input         PS2_CLK,
	input         PS2_DAT,
	
	// PS/2 Keyboard Monitor Port Signals
	output        PS2_CLK_MON, // GPIO0[2]
	output        PS2_DAT_MON, // GPIO0[3]
	
	// UART Transmitter Signal
	output        UART0_OUT,   // GPIO0[19]
	
	// Buzzer Control Signal
	output        PIEZO,       // GPIO0[0]

	// Logic Analyzer Test Point Signals
	input  [13:0] TP           // {GPIO0[30:22], GPIO0[11:7]}
);

	localparam CLOCK_50_RATE = 50000000; // 50 MHz

	// Unused LED Outputs
	assign HEX0 = 7'h7F;
	assign HEX3 = 7'h7F;
	assign LEDR = 10'h000;
	
	
	////////////////////////////////////////////////////////
	//
	// System Reset
	//
	wire sys_reset;
	
	System_Reset_Module
	#(
		.REF_CLK_RATE_HZ( CLOCK_50_RATE ),
		.POWER_ON_DELAY( 500 ) // ns
	)
	system_reset
	(
		// Input Signals
		.PLL_LOCKED( 1'b1 ),
		.REF_CLK( CLOCK_50 ),
		
		// Output Signals
		.RESET( sys_reset )
	);


	////////////////////////////////////////////////////////
	//
	// Switch Synchronizers
	//
	wire [1:0] sw_sync;
	
	Switch_Synchronizer_Bank
	#(
		.SWITCH_SYNC_CHANNELS( 2 ),
		.CLK_RATE_HZ( CLOCK_50_RATE ),
		.DEBOUNCE_TIME( 10000000 ), // 10 mS
		.SIG_OUT_INIT( 1'b0 )
	)
	switch_synchronizer
	(
		// Input  Signals (asynchronous)
		.SIG_IN( SW ),
		
		// Output Signals (synchronized to CLK domain)
		.SIG_OUT( sw_sync ),
		
		// System Signals
		.CLK( CLOCK_50 )
	);
	
	
	////////////////////////////////////////////////////////
	//
	// PS/2 Keyboard Module
	//
	wire       key_pressed;
	wire [7:0] key_keycode;
	wire [7:0] key_keychar;
	
	PS2_Keyboard_Module
	#(
		.CLK_RATE_HZ( CLOCK_50_RATE )
	)
	keyboard_interface
	(
		// PS/2 Bus Signals
		.PS2_CLK( PS2_CLK ),
		.PS2_DATA( PS2_DAT ),
		
		// Key Pressed Status Signals
		.KEY_PRESSED( key_pressed ),
		.KEY_KEYCODE( key_keycode ),
		.KEY_KEYCHAR( key_keychar ),
		
		// PS/2 Bus Monitor Signals
		.PS2_CLK_MONITOR( PS2_CLK_MON ),
		.PS2_DATA_MONITOR( PS2_DAT_MON ),
		.PS2_KEYCODE_MONITOR(  ),
		
		// System Signals
		.CLK( CLOCK_50 ),
		.RESET( sys_reset )
	);
	
	
	////////////////////////////////////////////////////////
	//
	// Segment Display Keypress Status
	//
	PS2_Keyboard_Display_Controller seg_display_keycode_status
	(
		// PS/2 Keyboard Signals
		.KEY_PRESSED( key_pressed ),
		.KEY_DATA( key_keycode ),
		
		// 7-Segment Display Signals
		.HEX0( HEX4 ),
		.HEX1( HEX5 ),
		
		// System Signals
		.CLK( CLOCK_50 )
	);

	PS2_Keyboard_Display_Controller seg_display_keychar_status
	(
		// PS/2 Keyboard Signals
		.KEY_PRESSED( key_pressed ),
		.KEY_DATA( key_keychar ),
		
		// 7-Segment Display Signals
		.HEX0( HEX1 ),
		.HEX1( HEX2 ),
		
		// System Signals
		.CLK( CLOCK_50 )
	);
	

	////////////////////////////////////////////////////////
	//
	// Serial UART Keypress Reporter
	//
	Serial_UART_Keypress_Reporter
	#(
		.CLK_RATE_HZ( CLOCK_50_RATE ),
		.BAUD_RATE( 115200 ),  // Baud
		.DATA_BITS( 8 ),
		.STOP_BITS_TX( 1 )
	)
	uart_keypress_reporter
	(
		// UART Bus Signals
		.UART_TX( UART0_OUT ),

		// UART Transmitter Signals
		.TX_SEND( key_pressed ),
		.TX_DATA( key_keychar ),
		.TX_DONE(  ),

		// System Signals
		.CLK( CLOCK_50 ),
		.RESET( sys_reset )
	);


	////////////////////////////////////////////////////////
	//
	// Morse Code Module
	//
	wire mc_tx_sig;
	
	Morse_Code_Module
	#(
		.CLK_RATE_HZ( CLOCK_50_RATE ), // MHz
		.XMIT_RATE( 70000 ) // uS/bit
	)
	morse_code_tx
	(
		// Input Signals
		.ENABLE( 1'b1 ),
		.SEND( key_pressed ),
		.CHAR( key_keychar ),
		
		// Output Signals
		.DONE(  ),
		.MC_OUT( mc_tx_sig ),
		
		// System Signals
		.CLK( CLOCK_50 ),
		.RESET( sys_reset )
	);

	
	////////////////////////////////////////////////////////
	//
	// Buzzer Tone Generator
	//
	Buzzer_Tone_Generator
	#(
		.CLK_RATE_HZ( CLOCK_50_RATE )
	)
	tone_generator
	(
		// Control Signals
		.TONE_ENABLE( mc_tx_sig ),
		.TONE_SELECT( sw_sync ),
			
		// Output Signals
		.TONE_OUT( PIEZO ),
		
		// System Signals
		.CLK( CLOCK_50 )
	);
	
endmodule
