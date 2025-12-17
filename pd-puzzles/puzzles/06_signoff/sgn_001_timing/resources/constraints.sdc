# SDC Constraints for ALU design
# Target: 100 MHz (10 ns period)

# Create clock
create_clock -name clk -period 10.0 [get_ports clk]

# Clock uncertainty (jitter + skew margin)
# Setup uncertainty (pessimistic for max delay)
set_clock_uncertainty -setup 0.2 [get_clocks clk]
# Hold uncertainty (smaller, realistic for min delay)
set_clock_uncertainty -hold 0.05 [get_clocks clk]

# Input delays (external logic delay)
set_input_delay -clock clk 2.0 [get_ports rst_n]
set_input_delay -clock clk 2.0 [get_ports {a[*]}]
set_input_delay -clock clk 2.0 [get_ports {b[*]}]
set_input_delay -clock clk 2.0 [get_ports {op[*]}]

# Output delays (external logic requirement)
set_output_delay -clock clk 2.0 [get_ports {result[*]}]
set_output_delay -clock clk 2.0 [get_ports zero]
