# Timing constraints for counter
# Target: 100 MHz (10ns period)

# Clock definition
create_clock -name clk -period 10.0 [get_ports clk]

# TODO: Add input_delay constraints for rst_n and enable
# Without input_delay, STA assumes inputs arrive at time 0 (unrealistic!)
set_input_delay -clock clk 2.0 [get_ports rst_n]
set_input_delay -clock clk 2.0 [get_ports enable]

# TODO: Add output_delay constraints for count[7:0]
# Without output_delay, STA has no timing requirement for outputs!
set_output_delay -clock clk 2.0 [get_ports count[*]]


# Driving cell and load (these alone are NOT enough for timing!)
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 [all_inputs]
set_load 0.05 [all_outputs]
