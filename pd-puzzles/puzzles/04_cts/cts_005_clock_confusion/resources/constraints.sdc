# CTS_005: Clock Confusion - Timing Constraints
# Clock period: 2ns (500 MHz target)

create_clock -name CLK -period 2.0 [get_ports clk]

set_input_delay -clock CLK 0.3 [get_ports {a[*] b[*] valid_in op_mode[*]}]
set_output_delay -clock CLK 0.3 [get_ports {result[*] valid_out carry_out overflow}]

set_max_fanout 20 [current_design]
set_max_transition 0.3 [current_design]
