# Constraints for Matrix Multiplier
# Target: 250 MHz (4.0 ns period)

create_clock -name clk -period 4.0 [get_ports clk]

set_clock_uncertainty 0.15 [get_clocks clk]

# Input delays
set_input_delay -clock clk 0.8 [get_ports rst_n]
set_input_delay -clock clk 0.8 [get_ports {a*}]
set_input_delay -clock clk 0.8 [get_ports {b*}]
set_input_delay -clock clk 0.8 [get_ports start]
set_input_delay -clock clk 0.8 [get_ports accumulate]

# Output delays
set_output_delay -clock clk 0.8 [get_ports {c*}]
set_output_delay -clock clk 0.8 [get_ports done]
set_output_delay -clock clk 0.8 [get_ports overflow]

set_max_transition 0.2 [current_design]
set_max_fanout 16 [current_design]
