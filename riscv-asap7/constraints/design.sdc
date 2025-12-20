# ============================================================================
# RISC-V SoC Timing Constraints for ASAP7 (7nm)
# ============================================================================
# Target: 500 MHz (2ns period) - aggressive for learning
# ============================================================================

# Clock definition
create_clock -name clk -period 2.0 [get_ports clk]

# Clock uncertainty (for setup/hold analysis)
set_clock_uncertainty 0.1 [get_clocks clk]

# Clock transition
set_clock_transition 0.05 [get_clocks clk]

# Input delays (relative to clock)
set_input_delay -clock clk -max 0.4 [get_ports rst_n]
set_input_delay -clock clk -min 0.1 [get_ports rst_n]

set_input_delay -clock clk -max 0.4 [get_ports gpio_in*]
set_input_delay -clock clk -min 0.1 [get_ports gpio_in*]

# Output delays
set_output_delay -clock clk -max 0.4 [get_ports gpio_out*]
set_output_delay -clock clk -min 0.1 [get_ports gpio_out*]

set_output_delay -clock clk -max 0.4 [get_ports debug_*]
set_output_delay -clock clk -min 0.1 [get_ports debug_*]

# False paths for reset
set_false_path -from [get_ports rst_n]

# Max fanout constraint
set_max_fanout 20 [current_design]

# Max transition constraint
set_max_transition 0.15 [current_design]

# Driving cell (typical ASAP7 buffer)
set_driving_cell -lib_cell BUFx2_ASAP7_75t_R -pin Y [all_inputs]

# Load capacitance (typical for ASAP7)
set_load 0.5 [all_outputs]
