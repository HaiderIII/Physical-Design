# SDC Constraints for Register File - Sky130HD
# Target: 100 MHz

create_clock -name clk -period 10.0 [get_ports clk]

set_input_delay -clock clk 2.0 [get_ports {we din[*]}]
set_output_delay -clock clk 2.0 [get_ports dout[*]]
