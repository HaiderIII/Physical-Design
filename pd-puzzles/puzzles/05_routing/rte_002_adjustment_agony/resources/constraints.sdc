# Timing constraints for shift_reg
# Target: 50 MHz (20ns period)

create_clock -name clk -period 20.0 [get_ports clk]

set_input_delay -clock clk 2.0 [get_ports {rst_n shift_en serial_in load}]
set_input_delay -clock clk 2.0 [get_ports parallel_in[*]]

set_output_delay -clock clk 2.0 [get_ports serial_out]
set_output_delay -clock clk 2.0 [get_ports parallel_out[*]]

# Driving cell and load
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 [all_inputs]
set_load 0.05 [all_outputs]
