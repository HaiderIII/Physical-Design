# Hints - SGN_002 The Constraint Crisis

Try to solve the puzzle yourself first! Use these hints only if stuck.

---

## Hint 1 - Where to Look

The bug is in `resources/constraints.sdc`, not in `run.tcl`.

Look for the TODO comments in the SDC file.

---

## Hint 2 - What's Missing

The SDC file has:
- Clock definition ✓
- Driving cell ✓
- Output load ✓

But is missing:
- Input delay constraints
- Output delay constraints

---

## Hint 3 - Input Delay Syntax

To specify when inputs arrive relative to the clock:
```sdc
set_input_delay -clock <clock_name> <delay_value> [get_ports <port_list>]
```

Example:
```sdc
set_input_delay -clock clk 2.0 [get_ports {rst_n enable}]
```

---

## Hint 4 - Output Delay Syntax

To specify when outputs must be ready:
```sdc
set_output_delay -clock <clock_name> <delay_value> [get_ports <port_list>]
```

Example:
```sdc
set_output_delay -clock clk 2.0 [get_ports count[*]]
```

---

## Hint 5 - The Complete Fix

Add these two lines to `constraints.sdc`:
```sdc
set_input_delay -clock clk 2.0 [get_ports {rst_n enable}]
set_output_delay -clock clk 2.0 [get_ports count[*]]
```

A typical delay value of 2.0ns assumes the external logic has ~2ns of delay.

---

## Still Stuck?

Check `.solution/EXPLANATION.md` for the full explanation.
