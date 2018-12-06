`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    15:02:00 02/05/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #3 Project
// Module Name:    PS2_Keyboard_Display_Controller
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v15.0
// Description:    7-Segment Display Controller for Keyboard Status 
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module PS2_Keyboard_Display_Controller
(
	// PS/2 Keyboard Signals
	input        KEY_PRESSED,
	input  [7:0] KEY_DATA,
	
	// 7-Segment Display Signals
	output reg [6:0] HEX0,
	output reg [6:0] HEX1,
	
	// System Signals
	input CLK
);

	wire [6:0] seg_hex0;
	wire [6:0] seg_hex1;
	
	
	//
	// Key Code translation for Hex Value Segment Display
	//
	Hex_Segment_Decoder
	#(
		.HEX_DIGITS( 2 )
	)
	segment_transcoder
	(
		// BCD Input (Packed Array)
		.HEX_IN( KEY_DATA ),
		
		// Seven-Segment Output (Packed Array)
		.SEG_OUT( { seg_hex1, seg_hex0 } ),
		
		// System Signals
		.CLK( CLK )
	);
	
	
	//
	// Segment Display Output Registers
	//
	wire   key_code_blank;	
	assign key_code_blank = (KEY_DATA == 8'h00) ? 1'b1 : 1'b0;
	
	always @(posedge CLK)
	begin
		HEX0 <= key_code_blank ? 7'h7F : ~seg_hex0;
		HEX1 <= key_code_blank ? 7'h7F : ~seg_hex1;
	end

endmodule
