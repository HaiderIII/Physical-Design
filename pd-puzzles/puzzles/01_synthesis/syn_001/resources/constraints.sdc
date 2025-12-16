#-----------------------------------------------------------------------------
# SDC Constraints for counter design
# Target: 100 MHz (10 ns period)
#-----------------------------------------------------------------------------

# Create clock
create_clock -name clk -period 10.0 [get_ports clk]

# Clock uncertainty (jitter + skew estimate)
set_clock_uncertainty 0.2 [get_clocks clk]

# Input delays (relative to clock)
set_input_delay -clock clk 2.0 [get_ports rst_n]
set_input_delay -clock clk 2.0 [get_ports enable]

# Output delays (relative to clock)
set_output_delay -clock clk 2.0 [get_ports count[*]]

# Drive strength and load assumptions
set_driving_cell -lib_cell BUF_X1 [all_inputs]
set_load 0.01 [all_outputs]
