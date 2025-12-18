# Solution Explanation - SGN_002 The Constraint Crisis

## The Problem

The original `constraints.sdc` was missing I/O delay constraints:
```sdc
# Only had clock and driving cell/load
create_clock -name clk -period 10.0 [get_ports clk]
set_driving_cell -lib_cell sky130_fd_sc_hd__buf_2 [all_inputs]
set_load 0.05 [all_outputs]
```

This caused I/O paths to be **unconstrained** - STA didn't analyze them!

## The Solution

Add input and output delay constraints:
```sdc
set_input_delay -clock clk 2.0 [get_ports {rst_n enable}]
set_output_delay -clock clk 2.0 [get_ports count[*]]
```

## Understanding I/O Delays

### Input Delay

```
                   YOUR DESIGN
External          ┌──────────────────┐
  FF              │                  │
┌────┐    ────────┤ Input Port       │
│ Q  ├────────────►                  │
└────┘   ↑        │                  │
         │        └──────────────────┘
    input_delay
    (Tco + routing)
```

`set_input_delay` models:
- External flip-flop clock-to-Q delay
- Board/chip routing delay
- Clock skew between chips

### Output Delay

```
YOUR DESIGN                External
┌──────────────────┐         FF
│                  │       ┌────┐
│      Output Port ├───────► D  │
│                  │──────┤    │
└──────────────────┘  ↑   └────┘
                      │
              output_delay
              (routing + Tsu)
```

`set_output_delay` models:
- Board/chip routing delay
- External flip-flop setup time
- Clock skew margin

## Why This Matters

Without I/O delays:
1. **False confidence**: Design appears to pass timing
2. **Hidden issues**: Real I/O timing problems are missed
3. **Silicon failures**: Chip may not work with real interfaces

## Complete SDC Checklist

For proper signoff, your SDC should have:

1. **Clock definition**: `create_clock`
2. **Input delays**: `set_input_delay` for all inputs
3. **Output delays**: `set_output_delay` for all outputs
4. **Driving cells**: `set_driving_cell` for input characteristics
5. **Output loads**: `set_load` for output fanout

## Choosing Delay Values

| Constraint | Typical Value | Components |
|------------|---------------|------------|
| input_delay | 1-3 ns | Ext FF Tco (~1ns) + Routing (~1ns) |
| output_delay | 1-3 ns | Routing (~1ns) + Ext FF Tsu (~1ns) |

For high-speed interfaces, these values need careful analysis based on the actual system timing budget.

## Best Practices

1. **Always constrain all I/O ports** - no unconstrained paths
2. **Document delay assumptions** - comments in SDC
3. **Use realistic values** - based on system analysis
4. **Check for "No paths found"** - indicates missing constraints
