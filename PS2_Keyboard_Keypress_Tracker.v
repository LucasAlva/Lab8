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
	reg [2:0] state;
	localparam [2:0] 
		S0 = 3'b001,
		S1 = 3'b010,
		S2 = 3'b100;
	
	always @(posedge CLK, posedge RESET) begin
		if(RESET) begin
			state <= S0;
			KEY_PRESSED 	<= 1'b0;
			KEY_KEYCODE 	<= 8'h00;
			KEY_KEYCHAR 	<= 8'h00;
			key_keycode_reg<= 8'h00;
		end
		else begin
			case(state)
				S0: begin
					KEY_PRESSED <= 1'b0; 	// clear key press signal
					// update held key status ???
					// wait for the Key make signal
					if(KEY_MAKE)
						state <= S1;
				end
				
				S1:begin
					// now check for the key break signal and the data
					if(KEY_BREAK && (key_keycode_reg == KEY_DATA))
						state <= S2;
				end
				
				S2: begin
					KEY_KEYCODE <= key_keycode_reg; 	// output keycode data
					KEY_KEYCHAR <= key_keychar_reg; 	// output keychar data
					KEY_PRESSED <= 1'b1; 				// assert key pressed signal
					state 		<= S0;
				end
			
			endcase
		
		end
	
	end

endmodule
