# Timing constraints for DSP Core
# Target frequency: 100 MHz (10ns period)

create_clock -name clk -period 10.0 [get_ports clk]

set_clock_uncertainty 0.3 [get_clocks clk]
set_clock_transition 0.2 [get_clocks clk]

set_input_delay -clock clk -max 3.0 [get_ports {data_a[*] data_b[*] valid_in}]
set_input_delay -clock clk -min 0.5 [get_ports {data_a[*] data_b[*] valid_in}]

set_input_delay -clock clk -max 2.0 [get_ports rst_n]
set_input_delay -clock clk -min 0.3 [get_ports rst_n]

set_output_delay -clock clk -max 3.0 [get_ports {result[*] valid_out}]
set_output_delay -clock clk -min 0.5 [get_ports {result[*] valid_out}]

set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 [all_inputs]
set_load 0.05 [all_outputs]
