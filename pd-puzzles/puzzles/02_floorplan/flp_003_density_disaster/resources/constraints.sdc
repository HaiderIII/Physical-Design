# SDC Constraints for Datapath Unit
# Target: ASAP7 7nm - 1 GHz (1ns period)

# Clock definition
create_clock -name clk -period 1.0 [get_ports clk]

# Clock uncertainty for 7nm
set_clock_uncertainty 0.05 [get_clocks clk]

# Input delays
set_input_delay -clock clk 0.15 [get_ports rst_n]
set_input_delay -clock clk 0.15 [get_ports {data_in[*]}]
set_input_delay -clock clk 0.15 [get_ports {coeff[*]}]
set_input_delay -clock clk 0.15 [get_ports load]
set_input_delay -clock clk 0.15 [get_ports compute]

# Output delays
set_output_delay -clock clk 0.15 [get_ports {data_out[*]}]
set_output_delay -clock clk 0.15 [get_ports valid]
