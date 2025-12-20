# Solution - Skew Spiral

## The Bug

The `run.tcl` is missing the `set_wire_rc -clock` command before `clock_tree_synthesis`.

Without this, CTS runs without accurate wire RC estimation, generating warnings:
```
[WARNING EST-0027] no estimated parasitics. Using wire load models.
[WARNING EST-0018] wire capacitance for corner default is zero.
```

## The Fix

Add after floorplan, before placement:
```tcl
set_wire_rc -layer met2           # For signal nets
set_wire_rc -clock -layer met3    # For clock nets
```

Both are needed for complete parasitic estimation.

## Explanation

### What is Wire RC?

Wire RC (Resistance-Capacitance) characterizes the electrical properties of interconnect:
- **Resistance (R)**: Affects signal delay and voltage drop
- **Capacitance (C)**: Affects delay and power consumption

### Why Clock Needs Separate RC?

Clock nets are typically routed on higher metal layers because:
1. Lower resistance = faster transitions
2. Lower capacitance = less power
3. Better shielding options
4. Reduced coupling noise

### The set_wire_rc Command

```tcl
set_wire_rc -clock -layer met3
```

- `-clock`: Apply to clock nets (not signal nets)
- `-layer met3`: Use RC values from metal 3 layer

### Impact on CTS

Without proper wire RC:
| Aspect | Without RC | With RC |
|--------|------------|---------|
| Buffer sizing | Estimated | Accurate |
| Skew calculation | Approximate | Precise |
| Insertion delay | Unknown | Calculated |
| Power estimation | Missing | Available |

### Layer Selection Guidelines

| Layer | Use Case |
|-------|----------|
| met1/met2 | Local routing, short wires |
| met3/met4 | Clock trunks, medium distance |
| met5+ | Global clock distribution |

For Sky130HD, met3 is a good choice for clock routing.

## Quiz Answers

1. **B** - It enables accurate delay estimation for buffer sizing and skew calculation
2. **B** - They have lower resistance and capacitance per unit length
3. **B** - That these RC values apply to clock nets specifically
4. **B** - Wire RC values are not configured, using default models
5. **B** - Buffer sizing and skew estimation may be inaccurate
6. **B** - Before clock_tree_synthesis
7. **B** - set_wire_rc -clock command before CTS
