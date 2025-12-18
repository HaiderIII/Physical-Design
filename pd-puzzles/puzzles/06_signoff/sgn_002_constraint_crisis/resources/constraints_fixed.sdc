# Timing constraints for counter - FIXED VERSION
# Target: 100 MHz (10ns period)

# Clock definition
create_clock -name clk -period 10.0 [get_ports clk]

# FIXED: Input delay constraints
# Assume inputs come from external flip-flops with 2ns combinational delay
set_input_delay -clock clk 2.0 [get_ports rst_n]
set_input_delay -clock clk 2.0 [get_ports enable]

# FIXED: Output delay constraints
# Assume outputs go to external flip-flops that need 2ns setup time
set_output_delay -clock clk 2.0 [get_ports count[*]]

# Driving cell and load
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 [all_inputs]
set_load 0.05 [all_outputs]
