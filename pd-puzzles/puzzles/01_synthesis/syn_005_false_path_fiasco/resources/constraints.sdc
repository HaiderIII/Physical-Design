# Constraints for Burst Controller
# Target: 500 MHz (2.0 ns period)

create_clock -name clk -period 2.0 [get_ports clk]

set_clock_uncertainty 0.1 [get_clocks clk]

# Input delays
set_input_delay -clock clk 0.3 [get_ports rst_n]
set_input_delay -clock clk 0.3 [get_ports start_burst]
set_input_delay -clock clk 0.3 [get_ports {burst_length[*]}]
set_input_delay -clock clk 0.3 [get_ports {burst_mode[*]}]
set_input_delay -clock clk 0.3 [get_ports {data_in[*]}]
set_input_delay -clock clk 0.3 [get_ports data_valid]
set_input_delay -clock clk 0.3 [get_ports first_ack]

# Output delays
set_output_delay -clock clk 0.3 [get_ports burst_active]
set_output_delay -clock clk 0.3 [get_ports burst_done]
set_output_delay -clock clk 0.3 [get_ports {data_out[*]}]
set_output_delay -clock clk 0.3 [get_ports data_ready]
set_output_delay -clock clk 0.3 [get_ports first_beat]
set_output_delay -clock clk 0.3 [get_ports {first_data[*]}]
set_output_delay -clock clk 0.3 [get_ports {beat_count[*]}]
set_output_delay -clock clk 0.3 [get_ports error_flag]

# Design rules
set_max_transition 0.15 [current_design]
set_max_fanout 16 [current_design]

# =============================================================================
# FALSE PATH DECLARATIONS
# =============================================================================
#
# Intent: Exclude asynchronous reset from timing analysis
#
# BUG: The wildcard *rst* is TOO BROAD!
# It matches not just rst_n, but also:
#   - burst_mode (contains "rst")
#   - first_beat (contains "rst")
#   - first_data (contains "rst")
#   - first_ack (contains "rst")
#
# This disables timing analysis on CRITICAL DATA PATHS!

set_false_path -from [get_ports rst_n]
set_false_path -to [get_ports rst_n]

# Also trying to exclude "first" signals thinking they're initialization
# BUG: first_beat, first_data, first_ack are FUNCTIONAL signals!

