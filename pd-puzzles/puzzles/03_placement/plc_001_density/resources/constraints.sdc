# SDC Constraints for processor design
# Target: 100 MHz (10 ns period)

# Create clock
create_clock -name clk -period 10.0 [get_ports clk]

# Clock uncertainty
set_clock_uncertainty 0.2 [get_clocks clk]

# Input delays
set_input_delay -clock clk 2.0 [get_ports rst_n]
set_input_delay -clock clk 2.0 [get_ports {data_a[*]}]
set_input_delay -clock clk 2.0 [get_ports {data_b[*]}]
set_input_delay -clock clk 2.0 [get_ports {alu_op[*]}]
set_input_delay -clock clk 2.0 [get_ports load_a]
set_input_delay -clock clk 2.0 [get_ports load_b]

# Output delays
set_output_delay -clock clk 2.0 [get_ports {result[*]}]
set_output_delay -clock clk 2.0 [get_ports zero_flag]
set_output_delay -clock clk 2.0 [get_ports carry_flag]
