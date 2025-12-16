# Phase 7: Sign-off - Theory

## Overview

Sign-off is the final phase of the Physical Design flow. It performs comprehensive verification to ensure the design is ready for manufacturing. This phase catches any remaining issues before sending the design to the foundry (tape-out).

## What is Sign-off?

**Sign-off** is the process of:
- Verifying all design rules are satisfied (DRC)
- Confirming layout matches schematic (LVS)
- Ensuring timing meets requirements at all corners
- Validating power integrity
- Checking signal integrity
- Final quality assurance

This is the last checkpoint before manufacturing - errors caught here save millions of dollars!

## Sign-off Components

### DRC (Design Rule Check)

**Purpose:**
- Verify layout follows foundry rules
- Ensure manufacturability
- Catch geometric violations

**What DRC Checks:**
- Minimum spacing between wires
- Minimum wire width
- Via enclosure rules
- Density requirements
- Antenna rules
- Well and substrate rules

**DRC Categories:**

1. **Spacing Rules:**
   - Metal-to-metal spacing
   - Via-to-via spacing
   - Different net vs same net rules

2. **Width Rules:**
   - Minimum width
   - Maximum width (for current)

3. **Enclosure Rules:**
   - Via enclosure by metal
   - Contact enclosure

4. **Density Rules:**
   - Minimum metal density
   - Maximum metal density
   - For CMP (Chemical Mechanical Polishing)

5. **Antenna Rules:**
   - Ratio of metal area to gate area
   - Prevents gate damage during manufacturing

### LVS (Layout vs Schematic)

**Purpose:**
- Verify layout connectivity matches netlist
- Ensure no opens or shorts
- Confirm device parameters

**What LVS Checks:**

1. **Connectivity:**
   - All nets properly connected
   - No unintended shorts
   - No floating nodes

2. **Device Matching:**
   - Transistor count matches
   - Device sizes correct
   - Cell instances match

3. **Port Matching:**
   - I/O ports correctly placed
   - Port names match netlist

**LVS Flow:**

    Layout (GDSII/DEF) --> Extract Netlist
                              |
                              v
                          Compare <-- Schematic Netlist
                              |
                              v
                      Match / Mismatch

### STA (Static Timing Analysis)

**Purpose:**
- Verify timing at all process corners
- Ensure setup and hold timing met
- Check clock constraints satisfied

**Multi-Corner Analysis:**

| Corner | Process | Voltage | Temperature | Check |
|--------|---------|---------|-------------|-------|
| SS | Slow | Low (1.62V) | High (125°C) | Setup |
| FF | Fast | High (1.98V) | Low (-40°C) | Hold |
| TT | Typical | Nom (1.80V) | Nom (25°C) | Both |

**What STA Checks:**
- Setup timing at slow corner
- Hold timing at fast corner
- Clock skew and latency
- Clock domain crossings
- Recovery and removal times

### Power Analysis

**Purpose:**
- Verify power grid can deliver current
- Check for IR drop issues
- Ensure electromigration limits met

**IR Drop Analysis:**

    V_drop = I × R

If voltage drop too high:
- Cells may not function correctly
- Timing degrades
- Potential functional failure

**Electromigration (EM):**
- Current density limits
- Wire can fail over time
- Must size wires for current

**Power Grid Checks:**
- Voltage drop at all cells
- Current density in wires
- Via current limits

### Signal Integrity

**Purpose:**
- Verify signal quality
- Check for crosstalk issues
- Ensure noise margins met

**Crosstalk Analysis:**
- Coupling between adjacent wires
- Glitch analysis (functional failures)
- Delta delay (timing impact)

**Noise Analysis:**
- Power supply noise
- Substrate noise
- Electromagnetic coupling

## Sign-off Flow

### Typical Sign-off Sequence

1. **DRC Clean:**
   - Run full DRC
   - Fix all violations
   - Iterate until clean

2. **LVS Clean:**
   - Extract layout netlist
   - Compare with schematic
   - Fix any mismatches

3. **Timing Sign-off:**
   - Run STA at all corners
   - Verify setup and hold
   - Check all constraints

4. **Power Sign-off:**
   - Analyze IR drop
   - Check EM limits
   - Verify power grid

5. **Final Checks:**
   - Antenna check
   - Density check
   - Manufacturing checks

### Iterative Process

Sign-off often requires iterations:

    Run Check --> Violations Found --> Fix --> Re-run
                       |
                       v (if clean)
                  Move to Next Check

## DRC Details

### Common DRC Violations

**Spacing Violations:**
- Two wires too close
- Fix: Move wire or use different layer

**Width Violations:**
- Wire too narrow
- Fix: Widen wire

**Enclosure Violations:**
- Via not properly enclosed
- Fix: Extend metal around via

**Density Violations:**
- Too much or too little metal
- Fix: Add or remove fill patterns

**Antenna Violations:**
- Long wire connected to gate
- Fix: Add diode or break wire

### DRC Tools

**Industry Tools:**
- Calibre (Siemens)
- IC Validator (Synopsys)
- Pegasus (Cadence)

**Open Source:**
- Magic
- KLayout
- OpenROAD (basic checks)

### DRC Decks

**Technology-Specific Rules:**
- Provided by foundry
- Contains all design rules
- Regular updates for new rules

**Sky130 DRC:**
- Available in Magic format
- Covers all SKY130 rules
- Open source

## LVS Details

### LVS Flow Steps

1. **Layout Extraction:**
   - Read GDSII/DEF
   - Extract devices
   - Extract connectivity

2. **Schematic Netlist:**
   - Original synthesized netlist
   - Includes all instances
   - Port definitions

3. **Comparison:**
   - Match devices
   - Match connectivity
   - Report differences

### Common LVS Errors

**Opens:**
- Connection missing
- Wire not connected
- Via missing

**Shorts:**
- Unintended connection
- Wires touching
- Different nets connected

**Device Mismatch:**
- Wrong cell used
- Missing device
- Extra device

**Port Mismatch:**
- Port not connected
- Wrong port order
- Missing port

### LVS Tools

**Industry Tools:**
- Calibre LVS (Siemens)
- IC Validator (Synopsys)
- Pegasus (Cadence)

**Open Source:**
- Netgen
- Magic (extraction)

## Timing Sign-off

### Multi-Corner Multi-Mode

**Process Corners:**
- SS (Slow-Slow): Worst setup
- FF (Fast-Fast): Worst hold
- TT (Typical-Typical): Nominal
- SF/FS: Skewed corners

**Operating Modes:**
- Functional mode
- Test mode
- Sleep mode

**Full Analysis:**
- All corners × All modes
- Can be many combinations
- Focus on critical ones

### Sign-off STA

**Requirements:**
- Extracted parasitics (SPEF)
- Multi-corner libraries
- Accurate clock model

**Checks:**
- Setup slack > 0 (all corners)
- Hold slack > 0 (all corners)
- Max transition met
- Max capacitance met

### On-Chip Variation (OCV)

**What is OCV:**
- Variation within same chip
- Different parts of chip vary
- Affects timing analysis

**Derating:**
- Add pessimism for OCV
- Launch path: one delay
- Capture path: different delay

**AOCV/POCV:**
- Advanced OCV
- Location-based variation
- More accurate than flat OCV

## Power Sign-off

### IR Drop Analysis

**Static IR Drop:**
- Average current
- DC analysis
- Identifies weak spots

**Dynamic IR Drop:**
- Transient analysis
- Considers switching
- Worst case scenarios

**Acceptable Drop:**
- Typically < 5% of VDD
- For 1.8V: < 90mV
- Depends on design margins

### Electromigration

**Current Density Limits:**
- DC limit (continuous)
- AC limit (switching)
- Via limits

**EM Rules:**
- Provided by foundry
- Temperature dependent
- Lifetime dependent

### Power Grid Verification

**Checks:**
- Via count adequate
- Wire width sufficient
- Power mesh connected
- Decap placement

## Signal Integrity Sign-off

### Crosstalk Analysis

**Glitch Analysis:**
- Coupling causes false transitions
- Can cause functional failure
- Height and width of glitch

**Delta Delay:**
- Coupling changes timing
- Can cause violations
- Positive or negative delta

### Noise Analysis

**Power Supply Noise:**
- SSO (Simultaneous Switching Output)
- Ground bounce
- Decoupling requirements

**Substrate Noise:**
- Coupling through substrate
- Affects analog blocks
- Guard rings help

## Manufacturing Checks

### Density Fill

**Purpose:**
- Uniform metal density
- Better CMP results
- Prevents dishing

**Fill Insertion:**
- Add dummy metal
- Follow density rules
- Avoid coupling to signals

### Critical Area Analysis

**Purpose:**
- Estimate yield impact
- Identify vulnerable areas
- Improve manufacturability

**Defect Types:**
- Opens (broken wires)
- Shorts (bridged wires)
- Via failures

### Recommended Rules

**Beyond DRC:**
- Recommended spacing
- Preferred widths
- Yield-improving rules

## Sign-off Criteria

### Clean Design Requirements

1. **DRC Clean:**
   - Zero violations
   - All rules satisfied
   - Waived items documented

2. **LVS Clean:**
   - Perfect match
   - All devices verified
   - All connections correct

3. **Timing Clean:**
   - Positive slack all corners
   - All constraints met
   - Margins acceptable

4. **Power Clean:**
   - IR drop within limits
   - EM rules satisfied
   - Grid verified

### Waivers

**What Can Be Waived:**
- Known acceptable violations
- Tool limitations
- Design-specific exceptions

**Waiver Process:**
- Document reason
- Get approval
- Track for future

## Tools for Sign-off

### OpenROAD Capabilities

**Basic Checks:**
- DRC (limited)
- Timing analysis
- Power analysis

**Limitations:**
- Not full sign-off quality
- Missing some checks
- Use external tools

### External Tools

**For DRC/LVS:**
- Magic (open source)
- KLayout (open source)
- Netgen (open source)

**For Timing:**
- OpenSTA (open source)
- Built into OpenROAD

### Sky130 Sign-off

**Available Resources:**
- Magic DRC deck
- Netgen LVS setup
- Multi-corner libraries
- Documentation

## Best Practices

### For Learning

1. **Understand Each Check:**
   - Learn what DRC catches
   - Understand LVS purpose
   - Know timing requirements

2. **Run Incrementally:**
   - Check early and often
   - Don't wait until end
   - Fix issues as found

3. **Study Violations:**
   - Understand root cause
   - Learn from mistakes
   - Build knowledge

### For Production

1. **Automate Sign-off:**
   - Script all checks
   - Reproducible results
   - Track metrics

2. **Full Corner Coverage:**
   - All PVT corners
   - All operating modes
   - No shortcuts

3. **Document Everything:**
   - Waivers justified
   - Results recorded
   - Audit trail

## Summary

Sign-off is the final verification:
- **DRC:** Layout follows rules
- **LVS:** Layout matches netlist
- **STA:** Timing met at all corners
- **Power:** Grid delivers current
- **SI:** Signals are clean

All checks must pass before tape-out!

A clean sign-off means:
- Design is manufacturable
- Function is correct
- Timing is met
- Quality is verified

Sign-off takes time but prevents costly errors!

## Tape-out

After clean sign-off:
1. Generate final GDSII
2. Run final checks
3. Submit to foundry
4. Manufacturing begins!

Congratulations on completing the Physical Design flow!
