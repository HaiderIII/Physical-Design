# SGN_005: Hold Horror - Timing Constraints
# Clock period: 10ns (100 MHz)

create_clock -name clk -period 10.0 [get_ports clk]

set_input_delay -clock clk 1.0 [get_ports {data_a[*] data_b[*] sel enable mode[*]}]
set_output_delay -clock clk 1.0 [get_ports {result[*] valid}]

# BUG: Extremely restrictive constraints that will cause violations
set_max_fanout 20 [current_design]
set_max_transition 0.5 [current_design]
#set_max_capacitance 0.1 [current_design]

