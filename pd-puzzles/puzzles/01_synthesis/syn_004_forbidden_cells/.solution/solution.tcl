# Solution for SYN_004: Forbidden Cells

# Change this line in run.tcl (around line 76):

# FROM:
# set enable_forbidden_check false    ;# <-- BUG! Should be true

# TO:
set enable_forbidden_check true     ;# Fixed: Enable verification
