# RTE_005: Via Violation - Timing Constraints
# Clock period: 5ns (200 MHz target)

create_clock -name clk -period 5.0 [get_ports clk]

set_input_delay -clock clk 0.5 [get_ports {data_in[*] serial_in shift_en load_en shift_dir}]
set_output_delay -clock clk 0.5 [get_ports {data_out[*] serial_out_left serial_out_right}]

set_max_fanout 20 [current_design]
set_max_transition 0.5 [current_design]
