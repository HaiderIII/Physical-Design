# Timing constraints for Mixed-Signal Design
# Target frequency: 50 MHz (20ns period)

# Create main clock
create_clock -name clk -period 20.0 [get_ports clk]

# Clock uncertainty
set_clock_uncertainty 0.5 [get_clocks clk]

# Input delays
set_input_delay -clock clk -max 4.0 [get_ports {digital_in[*] analog_ctrl}]
set_input_delay -clock clk -min 1.0 [get_ports {digital_in[*] analog_ctrl}]

# Output delays
set_output_delay -clock clk -max 4.0 [get_ports {digital_out[*] analog_out_0 analog_out_1}]
set_output_delay -clock clk -min 1.0 [get_ports {digital_out[*] analog_out_0 analog_out_1}]

# Reset
set_input_delay -clock clk -max 3.0 [get_ports rst_n]

# Driving cell and load
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 [all_inputs]
set_load 0.05 [all_outputs]
