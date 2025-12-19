# SDC Constraints for ALU
# Target: ASAP7 7nm technology - 500 MHz (2ns period)

# Clock definition
create_clock -name clk -period 2.0 [get_ports clk]

# Clock uncertainty
set_clock_uncertainty 0.1 [get_clocks clk]

# Input delays
set_input_delay -clock clk 0.3 [get_ports {operand_a[*]}]
set_input_delay -clock clk 0.3 [get_ports {operand_b[*]}]
set_input_delay -clock clk 0.3 [get_ports op_sel]

# Output delays
set_output_delay -clock clk 0.3 [get_ports {result[*]}]
set_output_delay -clock clk 0.3 [get_ports zero_flag]
