# Constraints for DSP Engine
# Target: 250 MHz (4.0 ns period)

create_clock -name clk -period 4.0 [get_ports clk]

set_clock_uncertainty 0.15 [get_clocks clk]

# Input delays
set_input_delay -clock clk 0.8 [get_ports rst_n]
set_input_delay -clock clk 0.8 [get_ports {sample_*}]
set_input_delay -clock clk 0.8 [get_ports {coef_*}]
set_input_delay -clock clk 0.8 [get_ports mode*]
set_input_delay -clock clk 0.8 [get_ports accumulate]
set_input_delay -clock clk 0.8 [get_ports clear]

# Output delays
set_output_delay -clock clk 0.8 [get_ports {result_*}]
set_output_delay -clock clk 0.8 [get_ports {cycle_count[*]}]
set_output_delay -clock clk 0.8 [get_ports overflow]

set_max_transition 0.2 [current_design]
set_max_fanout 16 [current_design]
