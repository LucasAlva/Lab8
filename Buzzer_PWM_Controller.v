`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    13:15:00 09/24/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    Buzzer_PWM_Controller
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v17.0
// Description:    PWM Controller for Piezo Buzzer
//                 
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module Buzzer_PWM_Controller
#(
	parameter CLK_RATE_HZ = 50000000, // Hz
	parameter PWM_REG_WIDTH = 16	
)
(
	// Control Signals
	input                     PWM_ENABLE,
	input [PWM_REG_WIDTH-1:0] PWM_FREQ_COUNTS,
	input [PWM_REG_WIDTH-1:0] PWM_DUTY_COUNTS,
	
	// Output Signals
	output reg PWM_INTERVAL_TICK,
	output reg PWM_OUT,
	
	// System Signals
	input CLK
);

	wire                  pwm_interval_tick;	
	reg [PWM_REG_WIDTH:0] pwm_interval_counter_reg;
	reg [PWM_REG_WIDTH:0] pwm_dutytime_counter_reg;
	reg [PWM_REG_WIDTH:0] pwm_interval_loadval;
	reg [PWM_REG_WIDTH:0] pwm_dutytime_loadval;

	
	initial
	begin
		pwm_interval_counter_reg <= {1'b1, {PWM_REG_WIDTH{1'b0}}};
		pwm_dutytime_counter_reg <= {1'b1, {PWM_REG_WIDTH{1'b0}}};
		pwm_interval_loadval <= {1'b1, {PWM_REG_WIDTH{1'b0}}};
		pwm_dutytime_loadval <= {1'b1, {PWM_REG_WIDTH{1'b0}}};
		PWM_INTERVAL_TICK <= 1'b0;
		PWM_OUT <= 1'b0;
	end
	
	//
	// PWM Settings Register
	//
	always @(posedge CLK)
	begin
		pwm_interval_loadval = {1'b1, {PWM_REG_WIDTH{1'b0}}} + ~PWM_FREQ_COUNTS + 1'b1;
		pwm_dutytime_loadval = {1'b1, {PWM_REG_WIDTH{1'b0}}} + ~PWM_DUTY_COUNTS;
	end

	//
	// PWM Interval Timer Counter
	//
	assign pwm_interval_tick = pwm_interval_counter_reg[PWM_REG_WIDTH];

	always @(posedge CLK)
	begin
		if (pwm_interval_tick)
			pwm_interval_counter_reg <= pwm_interval_loadval;
		else
			pwm_interval_counter_reg <= pwm_interval_counter_reg + 1'b1;
	end

	//
	// PWM Duty Cycle On-time Counter
	//
	always @(posedge CLK)
	begin
		if (pwm_interval_tick)
			pwm_dutytime_counter_reg <= pwm_dutytime_loadval;
		else
			pwm_dutytime_counter_reg <= pwm_dutytime_counter_reg + 1'b1;
	end

	//
	// Output Interval Tick
	//
	always @(posedge CLK)
	begin
		PWM_INTERVAL_TICK <= pwm_interval_tick;
	end
	
	//
	// Output the PWM signal
	//
	always @(posedge CLK)
	begin
		if (PWM_ENABLE)
			PWM_OUT <= pwm_dutytime_counter_reg[PWM_REG_WIDTH];
		else
			PWM_OUT <= 1'b0;
	end

endmodule
