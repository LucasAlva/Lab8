`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    23:54:00 02/04/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    PS2_Keyboard_Serial_Controller
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v15.0
// Description:    PS/2 Keyboard Serial Controller
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module PS2_Keyboard_Serial_Controller
(
	// PS/2 Bus Signals (Synchronized to CLK)
	input  PS2_CLK_SYNC,
	input  PS2_DATA_SYNC,

	// PS/2 Serial Interface Signal
	output reg       PS2_KEY_READY,
	output reg [7:0] PS2_KEY_DATA,
	
	// System Signals
	input CLK,
	input RESET
);
	
	// Include StdFunctions for bit_index()
	`include "StdFunctions.vh"
	

	//
	// Compute Bit Count parameters
	//
	localparam BIT_COUNT_BITS = 10; // { 1 stop-bit, 1 parity-bit, 8 data-bits }
	localparam BIT_COUNT_WIDTH = bit_index(BIT_COUNT_BITS);
	localparam BIT_COUNT_LOADVAL = {1'b1, {BIT_COUNT_WIDTH{1'b0}}} - BIT_COUNT_BITS[BIT_COUNT_WIDTH-1:0];

	
	//
	// Parity Calculation
	//
	// The keyboard calculates Odd Parity by xor'ing each data bit:
	//
	//   parity_bit = d0 ^ d1 ^ d2 ^ d3 ^ d4 ^ d5 ^ d6 ^ d7
	//
	// This controller validates the received data's parity by xor'ing the 
	//   incoming data bits along with the incoming parity bit which 
	//   results in a matching status indicator, parity_good.
	//
	//   parity_good = (d0 ^ d1 ^ d2 ^ d3 ^ d4 ^ d5 ^ d6 ^ d7) ^ parity_bit
	//
	// Additionally, an optimization to reduce FSM logic was implemented that
	//   also xor's the stop-bit into the parity calculation. To compensate
	//   for the stop-bit's always 1 value, the initial value of parity_good
	//   was also set to 1 which negates the stop-bit.
	//
	// The final parity check equation used by this controller is:
	//
	//   ps2_parity_good = 1 ^ (^ps2_data_reg ^ parity_bit) ^ stop_bit
	//	
	// The ps2_parity_good signal will be high if the calculated parity 
	//   matches the transmitted parity, and low if not.
	//
	reg  ps2_parity_good;

	
	//
	// PS/2 Clock Falling-Edge Detector
	//
	wire ps2_clk_negedge;
	reg  ps2_clk_reg;

	initial
	begin
		ps2_clk_reg <= 1'b0;
	end
	
	// Clock Previous-Edge Register
	always @(posedge CLK)
	begin
		ps2_clk_reg <= PS2_CLK_SYNC;
	end

	// Detect a falling-edge by looking for a high to low transition by
	//   comparing the Previous-Edge register to the current clock signal.
	assign ps2_clk_negedge = ps2_clk_reg & ~PS2_CLK_SYNC;

	
	//
	// PS/2 Serial Controller State Machine
	//
	reg  [BIT_COUNT_WIDTH:0]  bit_count_reg;
	wire                      bit_count_done = bit_count_reg[BIT_COUNT_WIDTH];
	
	reg  [BIT_COUNT_BITS-1:0] ps2_data_reg; // { 1 stop-bit, 1 parity-bit, 8 data-bits }
	
	wire                      ps2_start_bit;
	wire                      ps2_stop_bit;
	
	// Start Bit happens on the falling clock edge when the Data line is low
	assign ps2_start_bit = ps2_clk_negedge & ~PS2_DATA_SYNC;
	
	// Stop Bit is the MSB of the data register
	assign ps2_stop_bit = ps2_data_reg[BIT_COUNT_BITS-1];
	
	
	// !! Lab 5: Add the PS2 Keyboard Serial Controller State Machine here !!
	
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
	always @(posedge CLK, posedge RESET)
	begin
		if(RESET)
		begin
			// do reset things
			state 				<= S0;
			PS2_KEY_READY 		<= 1'b0;
			PS2_KEY_DATA 		<= 8h'00;
			bit_count_reg 		<= BIT_COUNT_LOADVAL;
			ps2_data_reg 		<= 0;
			ps2_parity_good 	<= 1'b1;
		end
		else
		begin
			// State machine things
			case(state)
				S0:
				begin
					// S0 things
					bit_count_reg 		<= BIT_COUNT_LOADVAL;
					ps2_parity_good 	<= 1'b1;
					
					// change state when we see the ps2 start bit
					if(ps2_start_bit)
						state <= S1;
				end
				
				S1: 
				begin 
					// S1 things
					// wait for falling ps2 clk edge
					if(ps2_clk_negedge)
						state <= S2;
				end
				
				S2:
				begin
					// S2 things
					ps2_data_reg 		<= ps2_data_reg >> 1; 	// shift data reg to make room for received bit
					ps2_data_reg[9] 	<= PS2_DATA_SYNC; 		// insert the received bit
					bit_count_reg 		<= bit_count_reg + 1; 	// increment bit count
					ps2_parity_good 	<= ( 	1 ^ 
													ps2_data_reg[0] ^
													ps2_data_reg[1] ^	
													ps2_data_reg[2] ^
													ps2_data_reg[3] ^
													ps2_data_reg[4] ^
													ps2_data_reg[5] ^
													ps2_data_reg[6] ^
													ps2_data_reg[7] ^
													ps2_data_reg[8] ^
													ps2_data_reg[9]); // XOR fucken everything
					state 				<= S3;  						// proceed to arbitration state
				end
				
				S3:
				begin
					// S3 things
					if(bit_count_reg >= BIT_COUNT_BITS)	// this indicates done
						state <= S4
					else
						state <= S1
				end
				
				S4:
				begin
					// S4 things
					if(ps2_stop_bit && ps2_parity_good) begin
						PS2_KEY_DATA 	<= ps2_data_reg[7:0]; 	// output Key Data
						PS2_KEY_READY 	<= 1'b1; 					// assert Key Ready signal
					end
					state <= S5;
				end
				
				S5:
				begin
					// S5 things
					PS2_KEY_READY 	<= 1'b0;
					state <= S0;
				end
		end
	end

endmodule
