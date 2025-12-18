# Hints - PLC_002 The Timing Tunnel Vision

Read these hints progressively - try to solve the puzzle after each hint.

---

## Hint 1 - Understanding the Problem (reveal after 10 min)

<details>
<summary>Click to reveal</summary>

Look at the `global_placement` command around line 95 in `run.tcl`:

```tcl
global_placement -density 0.60
```

This command only specifies density. The placer has NO idea about timing!

The SDC file defines a 100 MHz clock (10ns period), but the placer doesn't use this information unless you tell it to.

</details>

---

## Hint 2 - The OpenROAD Option (reveal after 15 min)

<details>
<summary>Click to reveal</summary>

OpenROAD's `global_placement` command has a timing-driven mode.

Check the OpenROAD documentation or help:
```tcl
help global_placement
```

Look for an option that enables timing-driven placement. The option tells the placer to:
1. Read timing constraints
2. Identify critical paths
3. Prioritize short wire lengths for timing-critical nets

</details>

---

## Hint 3 - The Specific Flag (reveal after 20 min)

<details>
<summary>Click to reveal</summary>

The flag you need is `-timing_driven`

The corrected command should look like:

```tcl
global_placement -density 0.60 -timing_driven
```

This tells OpenROAD to:
- Use the SDC constraints loaded earlier
- Compute path criticalities
- Weight net placement by timing importance

</details>

---

## Key Concept

```
Without -timing_driven:           With -timing_driven:

  All nets weighted equally        Critical nets get priority

  [FF]----long wire----[Logic]    [FF]--short--[Logic]
        |                                |
        v                                v
  Total WL minimized               Critical path WL minimized
  But timing broken!               Timing preserved!
```

## How Timing-Driven Placement Works

1. **Path Analysis**: Placer runs static timing analysis
2. **Criticality**: Each net gets a criticality score (0.0 to 1.0)
3. **Weighting**: Critical nets (near 1.0) are weighted higher
4. **Optimization**: Placer minimizes weighted wirelength

```
Net criticality = slack_consumed / total_path_delay

criticality ~ 1.0 → Net is on critical path
criticality ~ 0.0 → Net has lots of slack
```

## Additional Tuning (Advanced)

For very tight timing, you can also try:
- Lower density (more room for optimization)
- Multiple placement iterations
- Incremental timing optimization

But first, just add `-timing_driven` and see the improvement!
