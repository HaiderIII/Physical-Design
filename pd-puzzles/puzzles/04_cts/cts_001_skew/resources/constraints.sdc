# SDC Constraints for pipeline design
# Target: 100 MHz (10 ns period)

# Create clock
create_clock -name clk -period 10.0 [get_ports clk]

# Clock uncertainty (includes jitter + skew margin)
set_clock_uncertainty 0.2 [get_clocks clk]

# Input delays
set_input_delay -clock clk 2.0 [get_ports rst_n]
set_input_delay -clock clk 2.0 [get_ports {data_in[*]}]
set_input_delay -clock clk 2.0 [get_ports valid_in]

# Output delays
set_output_delay -clock clk 2.0 [get_ports {data_out[*]}]
set_output_delay -clock clk 2.0 [get_ports valid_out]
