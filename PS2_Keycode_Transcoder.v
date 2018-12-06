`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    15:02:00 02/05/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    PS2_Keycode_Transcoder
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v15.0
// Description:    PS/2 Keycode to ASCII Transcoding Table
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module PS2_Keycode_Transcoder
(
	// Input Signals
	input      [7:0] KEY_CODE,
	
	// Output Signals
	output reg [7:0] KEY_CHAR,
	
	// System Signals
	input CLK
);

	always @(posedge CLK)
	begin
		case (KEY_CODE)
			8'h1C : KEY_CHAR <= 8'h41; // A
			8'h32 : KEY_CHAR <= 8'h42; // B
			8'h21 : KEY_CHAR <= 8'h43; // C
			8'h23 : KEY_CHAR <= 8'h44; // D
			8'h24 : KEY_CHAR <= 8'h45; // E
			8'h2B : KEY_CHAR <= 8'h46; // F
			8'h34 : KEY_CHAR <= 8'h47; // G
			8'h33 : KEY_CHAR <= 8'h48; // H
			8'h43 : KEY_CHAR <= 8'h49; // I
			8'h3B : KEY_CHAR <= 8'h4A; // J
			8'h42 : KEY_CHAR <= 8'h4B; // K
			8'h4B : KEY_CHAR <= 8'h4C; // L
			8'h3A : KEY_CHAR <= 8'h4D; // M
			8'h31 : KEY_CHAR <= 8'h4E; // N
			8'h44 : KEY_CHAR <= 8'h4F; // O
			8'h4D : KEY_CHAR <= 8'h50; // P
			8'h15 : KEY_CHAR <= 8'h51; // Q
			8'h2D : KEY_CHAR <= 8'h52; // R
			8'h1B : KEY_CHAR <= 8'h53; // S
			8'h2C : KEY_CHAR <= 8'h54; // T
			8'h3C : KEY_CHAR <= 8'h55; // U
			8'h2A : KEY_CHAR <= 8'h56; // V
			8'h1D : KEY_CHAR <= 8'h57; // W
			8'h22 : KEY_CHAR <= 8'h58; // X
			8'h35 : KEY_CHAR <= 8'h59; // Y
			8'h1A : KEY_CHAR <= 8'h5A; // Z
			8'h45 : KEY_CHAR <= 8'h30; // 0
			8'h16 : KEY_CHAR <= 8'h31; // 1
			8'h1E : KEY_CHAR <= 8'h32; // 2
			8'h26 : KEY_CHAR <= 8'h33; // 3
			8'h25 : KEY_CHAR <= 8'h34; // 4
			8'h2E : KEY_CHAR <= 8'h35; // 5
			8'h36 : KEY_CHAR <= 8'h36; // 6
			8'h3D : KEY_CHAR <= 8'h37; // 7
			8'h3E : KEY_CHAR <= 8'h38; // 8
			8'h46 : KEY_CHAR <= 8'h39; // 9
			8'h29 : KEY_CHAR <= 8'h20; // Space
			8'h5A : KEY_CHAR <= 8'h0D; // Enter (CR)
			default : KEY_CHAR <= 8'h00;
		endcase
	end

endmodule
