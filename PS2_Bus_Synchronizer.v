`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    18:11:00 09/24/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    PS2_Bus_Synchronizer
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v17.0
// Description:    PS/2 Bus Signal Synchronization
//
//                 Reuse the Switch_Debounce_Synchronizer to debounce and
//                 synchronize the PS/2 Clock and Data signals.
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module PS2_Bus_Synchronizer
#(
	parameter CLK_RATE_HZ = 50000000, // Hz
	parameter MIN_PULSE_TIME = 10000  // ns
)
(
	// PS/2 Bus Input Signals (asynchronous)
	input  PS2_CLK_IN,
	input  PS2_DATA_IN,
	
	// PS/2 Bus Output Signals (synchronized CLK domain)
	output PS2_CLK_OUT,
	output PS2_DATA_OUT,
	
	// System Signals
	input CLK
);

	//
	// PS/2 CLK Debounce Synchronizer
	//
	Switch_Debounce_Synchronizer
	#(
		.CLK_RATE_HZ( CLK_RATE_HZ ),
		.DEBOUNCE_TIME( MIN_PULSE_TIME ),
		.SIG_OUT_INIT( 1'b1 )    // Idle High
	)
	PS2_CLK_Sync
	(
		// Input  Signals (asynchronous)
		.SIG_IN( PS2_CLK_IN ),
		
		// Output Signals (synchronized to CLK domain)
		.SIG_OUT( PS2_CLK_OUT ),
		
		// System Signals
		.CLK( CLK )
	);

	//
	// PS/2 DATA Debounce Synchronizer
	//
	Switch_Debounce_Synchronizer
	#(
		.CLK_RATE_HZ( CLK_RATE_HZ ),
		.DEBOUNCE_TIME( MIN_PULSE_TIME ),
		.SIG_OUT_INIT( 1'b1 )    // Idle High
	)
	PS2_DATA_Sync
	(
		// Input  Signals (asynchronous)
		.SIG_IN( PS2_DATA_IN ),
		
		// Output Signals (synchronized to CLK domain)
		.SIG_OUT( PS2_DATA_OUT ),
		
		// System Signals
		.CLK( CLK )
	);

endmodule
