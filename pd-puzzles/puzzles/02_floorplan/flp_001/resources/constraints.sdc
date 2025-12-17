# SDC Constraints for data_path design
# Target: 200 MHz (5 ns period)

# Create clock
create_clock -name clk -period 5.0 [get_ports clk]

# Clock uncertainty
set_clock_uncertainty 0.1 [get_clocks clk]

# Input delays
set_input_delay -clock clk 1.0 [get_ports rst_n]
set_input_delay -clock clk 1.0 [get_ports data_in[*]]
set_input_delay -clock clk 1.0 [get_ports valid_in]

# Output delays
set_output_delay -clock clk 1.0 [get_ports data_out[*]]
set_output_delay -clock clk 1.0 [get_ports valid_out]
