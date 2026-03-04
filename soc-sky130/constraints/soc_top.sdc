# ==============================================================================
# SDC Constraints - SoC Top Level (soc_top)
# ==============================================================================
# Project: RISC-V SoC - Hierarchical Physical Design (SKY130)
# Target: 100 MHz (10 ns period)
# ==============================================================================

# ------------------------------------------------------------------------------
# Clock definition
# ------------------------------------------------------------------------------
create_clock -name clk -period 10.0 [get_ports clk]

# Clock uncertainty (jitter + skew)
set_clock_uncertainty 0.5 [get_clocks clk]

# Clock transition
set_clock_transition 0.15 [get_clocks clk]

# ------------------------------------------------------------------------------
# Input delays
# ------------------------------------------------------------------------------
# External inputs arrive 2ns after clock edge (20% of period)
set_input_delay -clock clk 2.0 [get_ports rst_n]
set_input_delay -clock clk 2.0 [get_ports uart_rx]
set_input_delay -clock clk 2.0 [get_ports spi_miso]
set_input_delay -clock clk 2.0 [get_ports gpio_in[*]]

# ------------------------------------------------------------------------------
# Output delays
# ------------------------------------------------------------------------------
# Outputs must be stable 2ns before next clock edge
set_output_delay -clock clk 2.0 [get_ports uart_tx]
set_output_delay -clock clk 2.0 [get_ports spi_sclk]
set_output_delay -clock clk 2.0 [get_ports spi_mosi]
set_output_delay -clock clk 2.0 [get_ports spi_cs_n]
set_output_delay -clock clk 2.0 [get_ports gpio_out[*]]
set_output_delay -clock clk 2.0 [get_ports gpio_oe[*]]
set_output_delay -clock clk 2.0 [get_ports debug_pc[*]]
set_output_delay -clock clk 2.0 [get_ports debug_instr[*]]
set_output_delay -clock clk 2.0 [get_ports irq_uart]
set_output_delay -clock clk 2.0 [get_ports irq_spi]
set_output_delay -clock clk 2.0 [get_ports irq_timer]
set_output_delay -clock clk 2.0 [get_ports irq_gpio]

# ------------------------------------------------------------------------------
# Driving cell and load
# ------------------------------------------------------------------------------
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 [all_inputs]
set_load 0.05 [all_outputs]

# ------------------------------------------------------------------------------
# Max fanout
# ------------------------------------------------------------------------------
set_max_fanout 20 [current_design]

# ------------------------------------------------------------------------------
# False paths
# ------------------------------------------------------------------------------
# Reset is async, false path for timing
set_false_path -from [get_ports rst_n]
