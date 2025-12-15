# Timing constraints for ALU 8-bit design

# Clock definition
# Target frequency: 50 MHz (period = 20 ns)
create_clock -name clk -period 20.0 [get_ports clk]

# Clock uncertainty (jitter + skew)
set_clock_uncertainty 0.5 [get_clocks clk]

# Clock transition
set_clock_transition 0.1 [get_clocks clk]

# Input delays (relative to clock)
# Assume inputs arrive 2ns after clock edge
set_input_delay -clock clk 2.0 [get_ports {a[*]}]
set_input_delay -clock clk 2.0 [get_ports {b[*]}]
set_input_delay -clock clk 2.0 [get_ports {opcode[*]}]
set_input_delay -clock clk 2.0 [get_ports rst_n]

# Output delays (relative to clock)
# Outputs must be stable 2ns before next clock edge
set_output_delay -clock clk 2.0 [get_ports {result[*]}]
set_output_delay -clock clk 2.0 [get_ports zero]
set_output_delay -clock clk 2.0 [get_ports carry]
set_output_delay -clock clk 2.0 [get_ports overflow]

# Input transition time
set_input_transition 0.2 [all_inputs]

# Load capacitance on outputs (in pF)
set_load 0.05 [all_outputs]

# Operating conditions
# Use typical corner (tt_025C_1v80)
set_operating_conditions -analysis_type on_chip_variation

# Don't touch reset network
set_dont_touch_network [get_ports rst_n]
set_dont_touch_network [get_ports clk]
