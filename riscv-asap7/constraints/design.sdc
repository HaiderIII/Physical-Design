# ============================================================================
# RISC-V SoC Timing Constraints for ASAP7 (7nm)
# ============================================================================
# Fréquence cible: 500 MHz (période 2ns)
# C'est agressif pour un design avec fake SRAM !
# ============================================================================

# Définition de l'horloge
# 500 MHz = période de 2 ns
create_clock -name clk -period 2.0 [get_ports clk]

# Incertitude d'horloge (marge pour setup/hold)
set_clock_uncertainty 0.1 [get_clocks clk]

# Transition d'horloge
set_clock_transition 0.05 [get_clocks clk]

# Délais d'entrée (relatifs à l'horloge)
set_input_delay -clock clk -max 0.5 [get_ports rst_n]
set_input_delay -clock clk -min 0.1 [get_ports rst_n]

set_input_delay -clock clk -max 0.5 [get_ports gpio_in*]
set_input_delay -clock clk -min 0.1 [get_ports gpio_in*]

# Délais de sortie
set_output_delay -clock clk -max 0.5 [get_ports gpio_out*]
set_output_delay -clock clk -min 0.1 [get_ports gpio_out*]

set_output_delay -clock clk -max 0.5 [get_ports debug_*]
set_output_delay -clock clk -min 0.1 [get_ports debug_*]

# False path pour le reset (asynchrone)
set_false_path -from [get_ports rst_n]

# Contrainte de fanout max
set_max_fanout 20 [current_design]

# Contrainte de transition max
set_max_transition 0.1 [current_design]

# Cellule de drive pour les entrées (buffer ASAP7)
set_driving_cell -lib_cell BUFx2_ASAP7_75t_R [all_inputs]

# Capacité de charge pour les sorties (en fF)
set_load 1.0 [all_outputs]
