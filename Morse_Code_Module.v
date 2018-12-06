`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    22:23:00 01/17/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    Morse_Code_Module
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v17.0
// Description:    Morse Code Module
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module Morse_Code_Module
#(
	parameter CLK_RATE_HZ = 50000000, // Hz
	parameter XMIT_RATE = 70000 // uS/bit
)
(
	// Input Signals
	input       ENABLE,
	input       SEND,
	input [7:0] CHAR,
	
	// Output Signals
	output DONE,
	output MC_OUT,
	
	// System Signals
	input CLK,
	input RESET
);

	// Include Standard Functions header file (needed for bit_index())
	`include "StdFunctions.vh"

	
	//	MORSE CODE ENCODING TABLE
	//	-------------------------
	//	A .-    10111          5
	//	B -...  111010101      9
	//	C -.-.  11101011101    11
	//	D -..   1110101        7
	//	E .     1              1
	//	F ..-.  101011101      9
	//	G --.   111011101      9
	//	H ....  1010101        7
	//	I ..    101            3
	//	J .---  1011101110111  13
	//	K -.-   111010111      9
	//	L .-..  101110101      9
	//	M --    1110111        7
	//	N -.    11101          5
	//	O ---   11101110111    11
	//	P .--.  10111011101    11
	//	Q --.-  1110111010111  13
	//	R .-.   1011101        7
	//	S ...   10101          5
	//	T -     111            3
	//	U ..-   1010111        7
	//	V ...-  101010111      9
	//	W .--   101110111      9
	//	X -..-  11101010111    11
	//	Y -.--  1110101110111  13
	//	Z --..  11101110101    11	
	//	LET SPC 000            3
	//	WRD SPC 0000000        7 

	
	//
	// Morse Code Character Sequence ROM
	//
	reg   [4:0] seq_addr;
	wire [12:0] seq_data;
	wire  [3:0] seq_len;
	
	DROM_Nx32
	#(
		.WIDTH( 17 ),
		.REGOUT( 1 ),
		.INIT_00( { 13'b0000000000000, 4'd7  } ), //	WRD SPC 0000000        7 
		.INIT_01( { 13'b0000000000000, 4'd3  } ), //	LET SPC 000            3 
		.INIT_02( { 13'b0000000011101, 4'd5  } ), //	A .-    10111          5
		.INIT_03( { 13'b0000101010111, 4'd9  } ), //	B -...  111010101      9
		.INIT_04( { 13'b0010111010111, 4'd11 } ), //	C -.-.  11101011101    11
		.INIT_05( { 13'b0000001010111, 4'd7  } ), //	D -..   1110101        7
		.INIT_06( { 13'b0000000000001, 4'd1  } ), //	E .     1              1
		.INIT_07( { 13'b0000101110101, 4'd9  } ), //	F ..-.  101011101      9
		.INIT_08( { 13'b0000101110111, 4'd9  } ), //	G --.   111011101      9
		.INIT_09( { 13'b0000001010101, 4'd7  } ), //	H ....  1010101        7
		.INIT_0A( { 13'b0000000000101, 4'd3  } ), //	I ..    101            3
		.INIT_0B( { 13'b1110111011101, 4'd13 } ), //	J .---  1011101110111  13
		.INIT_0C( { 13'b0000111010111, 4'd9  } ), //	K -.-   111010111      9
		.INIT_0D( { 13'b0000101011101, 4'd9  } ), //	L .-..  101110101      9
		.INIT_0E( { 13'b0000001110111, 4'd7  } ), //	M --    1110111        7
		.INIT_0F( { 13'b0000000010111, 4'd5  } ), //	N -.    11101          5
		.INIT_10( { 13'b0011101110111, 4'd11 } ), //	O ---   11101110111    11
		.INIT_11( { 13'b0010111011101, 4'd11 } ), //	P .--.  10111011101    11
		.INIT_12( { 13'b1110101110111, 4'd13 } ), //	Q --.-  1110111010111  13
		.INIT_13( { 13'b0000001011101, 4'd7  } ), //	R .-.   1011101        7
		.INIT_14( { 13'b0000000010101, 4'd5  } ), //	S ...   10101          5
		.INIT_15( { 13'b0000000000111, 4'd3  } ), //	T -     111            3
		.INIT_16( { 13'b0000001110101, 4'd7  } ), //	U ..-   1010111        7
		.INIT_17( { 13'b0000111010101, 4'd9  } ), //	V ...-  101010111      9
		.INIT_18( { 13'b0000111011101, 4'd9  } ), //	W .--   101110111      9
		.INIT_19( { 13'b0011101010111, 4'd11 } ), //	X -..-  11101010111    11
		.INIT_1A( { 13'b1110111010111, 4'd13 } ), //	Y -.--  1110101110111  13
		.INIT_1B( { 13'b0010101110111, 4'd11 } ), //	Z --..  11101110101    11
		.INIT_1C( { 13'b0000000000000, 4'd0  } ), // Unused
		.INIT_1D( { 13'b0000000000000, 4'd0  } ), // Unused
		.INIT_1E( { 13'b0000000000000, 4'd0  } ), // Unused
		.INIT_1F( { 13'b0000000000000, 4'd0  } )  // Unused
	)
	MC_Encoding_ROM
	(	
		// Read Port Signals
		.ADDR( seq_addr ),
		.DATA_OUT( { seq_data, seq_len } ),
		.CLK( CLK )
	);

	
	// ASCII to MorseCode Indexing
	always @*
	begin
		case (CHAR)
			8'h41, 8'h61 : seq_addr <= 5'h02; // 'A', 'a'
			8'h42, 8'h62 : seq_addr <= 5'h03; // 'B', 'b'
			8'h43, 8'h63 : seq_addr <= 5'h04; // 'C', 'c'
			8'h44, 8'h64 : seq_addr <= 5'h05; // 'D', 'd'
			8'h45, 8'h65 : seq_addr <= 5'h06; // 'E', 'e'
			8'h46, 8'h66 : seq_addr <= 5'h07; // 'F', 'f'
			8'h47, 8'h67 : seq_addr <= 5'h08; // 'G', 'g'
			8'h48, 8'h68 : seq_addr <= 5'h09; // 'H', 'h'
			8'h49, 8'h69 : seq_addr <= 5'h0A; // 'I', 'i'
			8'h4A, 8'h6A : seq_addr <= 5'h0B; // 'J', 'j'
			8'h4B, 8'h6B : seq_addr <= 5'h0C; // 'K', 'k'
			8'h4C, 8'h6C : seq_addr <= 5'h0D; // 'L', 'l'
			8'h4D, 8'h6D : seq_addr <= 5'h0E; // 'M', 'm'
			8'h4E, 8'h6E : seq_addr <= 5'h0F; // 'N', 'n'
			8'h4F, 8'h6F : seq_addr <= 5'h10; // 'O', 'o'
			8'h50, 8'h70 : seq_addr <= 5'h11; // 'P', 'p'
			8'h51, 8'h71 : seq_addr <= 5'h12; // 'Q', 'q'
			8'h52, 8'h72 : seq_addr <= 5'h13; // 'R', 'r'
			8'h53, 8'h73 : seq_addr <= 5'h14; // 'S', 's'
			8'h54, 8'h74 : seq_addr <= 5'h15; // 'T', 't'
			8'h55, 8'h75 : seq_addr <= 5'h16; // 'U', 'u'
			8'h56, 8'h76 : seq_addr <= 5'h17; // 'V', 'v'
			8'h57, 8'h77 : seq_addr <= 5'h18; // 'W', 'w'
			8'h58, 8'h78 : seq_addr <= 5'h19; // 'X', 'x'
			8'h59, 8'h79 : seq_addr <= 5'h1A; // 'Y', 'y'
			8'h5A, 8'h7A : seq_addr <= 5'h1B; // 'Z', 'z'
			8'h20        : seq_addr <= 5'h00; // Word Space
			8'h00        : seq_addr <= 5'h01; // Letter Space
			default      : seq_addr <= 5'h00;
		endcase
	end
	
	
	
	//
	// MorseCode TX Rate Generator
	//
	localparam RATE_TICKS = (XMIT_RATE * 1000.0) / (1000000000.0 / CLK_RATE_HZ);
	localparam RATE_WIDTH = bit_index(RATE_TICKS);
	localparam RATE_PRESET = {1'b1, {(RATE_WIDTH-1){1'b0}}, 1'b1} - RATE_TICKS;
		
	reg [RATE_WIDTH:0] rate_counter;
	wire               rate_tick;
	
	assign rate_tick = rate_counter[RATE_WIDTH];

	always @(posedge CLK)
	begin
		if (ENABLE)
		begin
			if (rate_tick)
				rate_counter <= RATE_PRESET;
			else
				rate_counter <= rate_counter + 1'b1;
		end
		else
		begin
			// Set to rollover on next clock so transmitter starts right away
			rate_counter <= { 1'b0, {RATE_WIDTH-1{1'b1}}};
		end
	end
	
	
	//
	// Transmitter Module
	//
	Morse_Code_Transmitter transmitter
	(
		// Input Signals
		.SEND( SEND ),
		.SEQ_DATA( seq_data ),
		.SEQ_LEN( seq_len ),
		.RATE_TICK( rate_tick ),
		
		// Output Signals
		.DONE( DONE ),
		.MC_OUT( MC_OUT ),
		
		// System Signals
		.CLK( CLK ),
		.RESET( RESET )
	);
	
endmodule
