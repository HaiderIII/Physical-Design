# Timing constraints for counter - SOLUTION
# Target: 100 MHz (10ns period)

# Clock definition
create_clock -name clk -period 10.0 [get_ports clk]

# SOLUTION: Input delay constraints
# Assume external logic has ~2ns delay (FF Tco + routing)
set_input_delay -clock clk 2.0 [get_ports {rst_n enable}]

# SOLUTION: Output delay constraints
# Assume external logic needs 2ns setup time
set_output_delay -clock clk 2.0 [get_ports count[*]]

# Driving cell and load
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 [all_inputs]
set_load 0.05 [all_outputs]
