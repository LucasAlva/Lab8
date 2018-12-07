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
	// state machine variable definition
	reg [5:0] state;
	localparam [5:0]
		S0 = 6'b000001,
		S1 = 6'b000010,
		S2 = 6'b000100,
		S3 = 6'b001000,
		S4 = 6'b010000,
		S5 = 6'b100000;
	
	//
	// STATE MACHINE PROCESS
	//
	always @(posedge CLK, posedge RESET) begin
		if(RESET) begin
			state 				<= S0;
			KEY_PRESSED_MAKE 	<= 1'b0;
			KEY_PRESSED_BREAK <= 1'b0;
			KEY_PRESSED_DATA 	<= 8h'00;
			key_release_flag 	<= 1'b0;
		end
		
		else begin
		
			case(state)
				S0:
				begin
					// wait for Key Ready Signal
					if(KEY_READY)
						state <= S1;
				end
				
				S1:
				begin
					case(status_flag)
						2'h0: key_release_flag <= key_release_flag;
						2'h1: key_release_flag <= 1'b0;
						2'h2: key_release_flag <= 1'b1;
						2'h3: key_release_flag <= key_release_flag;
					endcase
					
					if(status_flag != 2h'0) begin
						state <= S0;
					end
					else begin
						state <= S2;
					end
					
				end
				
				S2:
				begin
					KEY_PRESSED_DATA <= KEY_DATA; 	// output Key Data
					if(key_release_flag)
						state <= S4;
					else
						state <= S3;
				end
				
				S3:
				begin
					KEY_PRESSED_MAKE 		<= 1'b1;
					KEY_PRESSED_BREAK 	<= 1'b0;
					state <= S5;
				end
				
				S4:
				begin
					KEY_PRESSED_MAKE 		<= 1'b0;
					KEY_PRESSED_BREAK 	<= 1'b1;
					state <= S5;
				end
				
				S5:
				begin
					// CLEAR CONTROL SIGNALS ??
					state <= S0;
				end
				
			endcase
		
		end
	end
	
endmodule
