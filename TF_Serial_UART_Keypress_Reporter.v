`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Case Western Reserve University
// Engineer: Matt McConnell
// 
// Create Date:    20:38:00 09/17/2017 
// Project Name:   EECS301 Digital Design
// Design Name:    Lab #5 Project
// Module Name:    TF_Serial_UART_Keypress_Reporter
// Target Devices: Altera Cyclone V
// Tool versions:  Quartus v17.0
// Description:    Serial UART Keypress Reporter Test Bench
//                 
// Dependencies:   
//
//////////////////////////////////////////////////////////////////////////////////

module TF_Serial_UART_Keypress_Reporter();


	//
	// System Clock Emulation
	//
	localparam CLK_RATE_HZ = 500000000; // 500 MHz
	localparam CLK_HALF_PER = ((1.0 / CLK_RATE_HZ) * 1000000000.0) / 2.0; // ns
	
	reg        CLK;
	
	initial
	begin
		CLK = 1'b0;
		forever #(CLK_HALF_PER) CLK = ~CLK;
	end


	//
	// Unit Under Test: Serial_UART_Keypress_Reporter
	//
	reg        RESET;
	reg        TX_SEND;
	reg  [7:0] TX_DATA;
	wire       TX_DONE;
	wire       UART_TX;
	
	Serial_UART_Keypress_Reporter
	#(
		.CLK_RATE_HZ( CLK_RATE_HZ ),
		.BAUD_RATE( 115200 ), // Baud (bits/s)
		.DATA_BITS( 8 ),
		.STOP_BITS_TX( 1 )
	)
	uut
	(
		// UART Bus Signals
		.UART_TX( UART_TX ),

		// UART Transmitter Signals
		.TX_SEND( TX_SEND ),
		.TX_DATA( TX_DATA ),
		.TX_DONE( TX_DONE ),

		// System Signals
		.CLK( CLK ),
		.RESET( RESET )
	);


	//
	// Test Sequence
	//
	initial
	begin
		
		// Initialize Signals
		RESET = 1'b1;

		TX_SEND = 1'b0;
		TX_DATA = 8'h00;
		
		#500;
		
		// Release Reset
		RESET = 1'b0;
		#500;
		
		// Send Data
		@(posedge CLK);
		TX_DATA = 8'hA5;
		TX_SEND = 1'b1;
		
		@(posedge CLK);
		TX_SEND = 1'b0;
		
	end
	
endmodule
