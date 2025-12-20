# Solution for FLP_004: Blockage Blunder

# Change these lines in run.tcl (around line 103-106):

# FROM:
# set blockage_llx 75
# set blockage_lly 75
# set blockage_urx 95    ;# <-- BUG! Should be <= 90
# set blockage_ury 95    ;# <-- BUG! Should be <= 90

# TO:
set blockage_llx 70    ;# Adjusted for 20x20 block
set blockage_lly 70
set blockage_urx 90    ;# Fixed: within core
set blockage_ury 90    ;# Fixed: within core
