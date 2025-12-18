# Timing constraints for Pipelined Datapath
# Target frequency: 125 MHz (8ns period)

# Create main clock
create_clock -name clk -period 8.0 [get_ports clk]

# Clock uncertainty (setup + jitter)
set_clock_uncertainty 0.25 [get_clocks clk]

# Clock transition
set_clock_transition 0.15 [get_clocks clk]

# Input delays (external logic delay)
set_input_delay -clock clk -max 2.5 [get_ports {data_a[*] data_b[*] op_sel[*] valid_in}]
set_input_delay -clock clk -min 0.3 [get_ports {data_a[*] data_b[*] op_sel[*] valid_in}]

# Reset has tighter constraints
set_input_delay -clock clk -max 1.5 [get_ports rst_n]
set_input_delay -clock clk -min 0.2 [get_ports rst_n]

# Output delays (external logic requirements)
set_output_delay -clock clk -max 2.5 [get_ports {result[*] valid_out}]
set_output_delay -clock clk -min 0.3 [get_ports {result[*] valid_out}]

# Driving cell and output load
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 [all_inputs]
set_load 0.05 [all_outputs]
