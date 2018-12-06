`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    13:15:00 09/24/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    Buzzer_Tone_Generator
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v17.0
// Description:    Tone Generator for Piezo Buzzer
//                 
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module Buzzer_Tone_Generator
#(
	parameter CLK_RATE_HZ = 50000000 // Hz
)
(
	// Control Signals
	input       TONE_ENABLE,
	input [1:0] TONE_SELECT,
		
	// Output Signals
	output      TONE_OUT,
	
	// System Signals
	input CLK
);

	// Include Standard Functions header file (needed for bit_index())
	`include "StdFunctions.vh"


	//
	// Tone Table
	//
	localparam TONE_FREQ_0 =  440; //  440 Hz (A4)
	localparam TONE_FREQ_1 =  932; //  932 Hz (A#5)
	localparam TONE_FREQ_2 = 1480; // 1480 Hz (F#6)
	localparam TONE_FREQ_3 = 4186; // 4186 Hz (C8) 
	
	// Compute the register size for the maximum number of clock cycle ticks (lowest frequency).
	localparam MIN_FREQ = TONE_FREQ_0;
	localparam MAX_FREQ_COUNTS = 1.0 * CLK_RATE_HZ / MIN_FREQ;
	localparam TONE_FREQ_WIDTH = bit_index(MAX_FREQ_COUNTS);
	
	// Compute the clock cycle ticks for each Tone.
	localparam [TONE_FREQ_WIDTH-1:0] TONE_COUNTS_0 = 1.0 * CLK_RATE_HZ / TONE_FREQ_0;
	localparam [TONE_FREQ_WIDTH-1:0]TONE_COUNTS_1 = 1.0 * CLK_RATE_HZ / TONE_FREQ_1;
	localparam [TONE_FREQ_WIDTH-1:0]TONE_COUNTS_2 = 1.0 * CLK_RATE_HZ / TONE_FREQ_2;
	localparam [TONE_FREQ_WIDTH-1:0]TONE_COUNTS_3 = 1.0 * CLK_RATE_HZ / TONE_FREQ_3;

	reg [TONE_FREQ_WIDTH-1:0] pwm_freq_counts;
	
	// Select the tone cycle count to set the PWM Frequency
	always @(posedge CLK)
	begin
		case (TONE_SELECT)
			2'h0 : pwm_freq_counts <= TONE_COUNTS_0; 
			2'h1 : pwm_freq_counts <= TONE_COUNTS_1; 
			2'h2 : pwm_freq_counts <= TONE_COUNTS_2; 
			2'h3 : pwm_freq_counts <= TONE_COUNTS_3; 
		endcase
	end

	
	//
	// Duty Cycle Setting
	//
	// Duty Cycle will be fixed to 50% of the selected frequency by dividing the frequency by 2.
	//
	wire [TONE_FREQ_WIDTH-1:0] pwm_duty_counts = { 1'b0, pwm_freq_counts [TONE_FREQ_WIDTH-1:1] };
	

	//
	// PWM Controller
	//
	Buzzer_PWM_Controller
	#(
		.CLK_RATE_HZ( CLK_RATE_HZ ),
		.PWM_REG_WIDTH( TONE_FREQ_WIDTH )
	)
	pwm_controller
	(
		// Control Signals
		.PWM_ENABLE( TONE_ENABLE ),
		.PWM_FREQ_COUNTS( pwm_freq_counts ),
		.PWM_DUTY_COUNTS( pwm_duty_counts ),
		
		// Output Signals
		.PWM_INTERVAL_TICK(  ),
		.PWM_OUT( TONE_OUT ),
		
		// System Signals
		.CLK( CLK )
	);

endmodule
