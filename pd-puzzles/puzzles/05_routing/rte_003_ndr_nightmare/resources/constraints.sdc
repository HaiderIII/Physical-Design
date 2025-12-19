# SDC Constraints for Counter - ASAP7
# Target: 1.5 GHz (667ps period)

# Clock definition
create_clock -name clk -period 0.667 [get_ports clk]

# Clock uncertainty
set_clock_uncertainty 0.030 [get_clocks clk]

# Input delays
set_input_delay -clock clk -max 0.200 [get_ports {enable rst_n}]
set_input_delay -clock clk -min 0.050 [get_ports {enable rst_n}]

# Output delays
set_output_delay -clock clk -max 0.200 [get_ports count[*]]
set_output_delay -clock clk -min 0.050 [get_ports count[*]]
