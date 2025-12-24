# ============================================================================
# RISC-V SoC Timing Constraints for SKY130 (130nm)
# ============================================================================
# Project: RISC-V Physical Design with SKY130 + SRAM Macros
# Target: 100 MHz (10ns period) - aggressive but achievable for 130nm
# ============================================================================

# Clock definition
create_clock -name clk -period 10.0 [get_ports clk]

# Clock uncertainty (for setup/hold analysis)
set_clock_uncertainty 0.3 [get_clocks clk]

# Clock transition
set_clock_transition 0.15 [get_clocks clk]

# Input delays (relative to clock)
set_input_delay -clock clk -max 2.0 [get_ports rst_n]
set_input_delay -clock clk -min 0.5 [get_ports rst_n]

set_input_delay -clock clk -max 2.0 [get_ports gpio_in*]
set_input_delay -clock clk -min 0.5 [get_ports gpio_in*]

# Output delays
set_output_delay -clock clk -max 2.0 [get_ports gpio_out*]
set_output_delay -clock clk -min 0.5 [get_ports gpio_out*]

set_output_delay -clock clk -max 2.0 [get_ports debug_*]
set_output_delay -clock clk -min 0.5 [get_ports debug_*]

# False paths for reset (asynchronous)
set_false_path -from [get_ports rst_n]

# Max fanout constraint
set_max_fanout 20 [current_design]

# Max transition constraint
set_max_transition 0.5 [current_design]

# Driving cell (SKY130 buffer)
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 -pin X [all_inputs]

# Load capacitance (typical for SKY130, in pF)
set_load 0.02 [all_outputs]
