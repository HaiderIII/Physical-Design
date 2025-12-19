# SDC Constraints for Pipeline - ASAP7
# Target: 1.5 GHz (667ps period)

# Clock definition
create_clock -name clk -period 0.667 [get_ports clk]

# Clock uncertainty (includes jitter and skew margin)
set_clock_uncertainty 0.030 [get_clocks clk]

# Clock transition
set_clock_transition 0.020 [get_clocks clk]

# Input delays
set_input_delay -clock clk -max 0.200 [get_ports {data_in[*] rst_n}]
set_input_delay -clock clk -min 0.050 [get_ports {data_in[*] rst_n}]

# Output delays
set_output_delay -clock clk -max 0.200 [get_ports data_out[*]]
set_output_delay -clock clk -min 0.050 [get_ports data_out[*]]
