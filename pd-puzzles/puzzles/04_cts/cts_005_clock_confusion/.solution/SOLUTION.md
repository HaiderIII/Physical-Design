# Solution: CTS_005 - Clock Confusion

## The Bug

In `resources/constraints.sdc`, the clock is defined with the wrong port name:

```tcl
create_clock -name CLK -period 2.0 [get_ports CLK]
set_input_delay -clock CLK 0.3 [get_ports {a[*] b[*] valid_in op_mode[*]}]
set_output_delay -clock CLK 0.3 [get_ports {result[*] valid_out carry_out overflow}]
```

But the Verilog design uses lowercase `clk`:

```verilog
input  wire        clk,
```

## Why This Causes Problems

1. **`get_ports CLK` returns empty**: The port doesn't exist
2. **Clock is created on nothing**: The constraint is effectively ignored
3. **CTS finds no clock**: Without a valid clock definition, CTS skips the design
4. **No timing paths**: Without a clock, there are no reg-to-reg paths

The insidious part: OpenROAD only issues a **warning**, not an error. The flow completes "successfully" but produces a broken result.

## The Fix

Change the SDC to use the correct port name (lowercase `clk`):

```tcl
create_clock -name clk -period 2.0 [get_ports clk]
set_input_delay -clock clk 0.3 [get_ports {a[*] b[*] valid_in op_mode[*]}]
set_output_delay -clock clk 0.3 [get_ports {result[*] valid_out carry_out overflow}]
```

## After the Fix

Running CTS now shows:
```
[INFO CTS-0007] Net "clk" found for clock "clk".
[INFO CTS-0010]  Clock net "clk" has 225 sinks.
[INFO CTS-0018]     Created 26 clock buffers.
```

And timing analysis works:
```
Worst Negative Slack (WNS): 0.420 ns
```

## Key Lessons

1. **Verilog is case-sensitive**: `clk` and `CLK` are different identifiers
2. **Warnings can be critical**: Don't ignore SDC warnings
3. **Validate your constraints**: Check that clock nets are found after CTS
4. **Consistent naming**: Use the same naming convention across RTL and constraints

## Quiz Answers

1. **C** - SDC clock port name doesn't match design port
2. **B** - Yes, clk and CLK are different ports
3. **A** - An empty collection
4. **C** - No clock tree is built (registers left unbalanced)
5. **B** - There's no valid clock to define timing paths
6. **A** - The flow continues but produces incorrect results
7. **B** - Add validation checks that clock nets are found after CTS
