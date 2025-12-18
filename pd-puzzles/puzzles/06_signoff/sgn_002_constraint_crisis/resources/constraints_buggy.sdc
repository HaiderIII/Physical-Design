# Timing constraints for counter - BUGGY VERSION
# Target: 100 MHz (10ns period)

# Clock definition
create_clock -name clk -period 10.0 [get_ports clk]

# BUG: Missing input_delay constraints!
# Without input_delay, STA assumes inputs arrive at time 0
# This is unrealistic and hides real timing problems

# BUG: Missing output_delay constraints!
# Without output_delay, STA assumes outputs can arrive anytime
# This doesn't account for downstream logic requirements

# Only driving cell and load are set (not enough!)
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 [all_inputs]
set_load 0.05 [all_outputs]

