transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/Switch_Synchronizer_Bank.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/Serial_UART_Keypress_Reporter.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/PS2_Keycode_Transcoder.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/PS2_Keyboard_Module.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/PS2_Keyboard_Keypress_Tracker.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/PS2_Keyboard_Keycode_Parser.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/PS2_Keyboard_Display_Controller.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/PS2_Bus_Synchronizer.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/Morse_Code_Transmitter.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/Hex_Segment_Decoder.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/EECS301_Lab5_TopLevel.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/DROM_Nx32.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/CDC_Input_Synchronizer.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/Buzzer_PWM_Controller.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/System_Reset_Module.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/Switch_Debounce_Synchronizer.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/Serial_UART_Transmitter.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/Serial_UART_Baud_Generator.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/PS2_Keyboard_Serial_Controller.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/Morse_Code_Module.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/Buzzer_Tone_Generator.v}

vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/Serial_UART_Transmitter.v}
vlog -vlog01compat -work work +incdir+D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8 {D:/College/SenrioYearTemp/EECS-301/EECS-301-Lab8/TF_Serial_UART_Keypress_Reporter.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  Serial_UART_Transmitter_tb

add wave *
view structure
view signals
run -all
