# SDC Constraints for ALU - Sky130HD
# Target: 50 MHz

create_clock -name clk -period 20.0 [get_ports clk]

set_input_delay -clock clk 4.0 [get_ports {a[*] b[*] op[*]}]
set_output_delay -clock clk 4.0 [get_ports result[*]]
