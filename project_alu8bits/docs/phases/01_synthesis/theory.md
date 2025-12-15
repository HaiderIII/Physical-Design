# Phase 1: Synthesis - Theory

## Overview

Synthesis is the first step in the Physical Design flow. It transforms RTL (Register Transfer Level) code written in HDL (Verilog/VHDL) into a gate-level netlist using standard cells from a technology library.

## What is Synthesis?

**Synthesis** converts behavioral/structural HDL descriptions into:
- A gate-level netlist (interconnected standard cells)
- Optimized for area, timing, and power
- Technology-mapped to the target PDK (Sky130 in our case)

## Synthesis Flow Steps

### 1. RTL Analysis
- Parse and analyze RTL code
- Check for syntax errors
- Build internal representation (AST - Abstract Syntax Tree)

### 2. Elaboration
- Resolve hierarchy
- Expand parameters and generate statements
- Create design database

### 3. Logic Optimization
- **Technology Independent**: Boolean optimization, constant propagation, dead code elimination
- Minimize logic gates without considering technology

### 4. Technology Mapping
- Map optimized logic to actual standard cells from PDK
- Consider cell delays, areas, and power
- Use library cells (sky130_fd_sc_hd)

### 5. Optimization
- **Technology Dependent**: Timing optimization, area recovery
- Meet timing constraints from SDC file
- Balance area vs. performance trade-offs

## Key Concepts

### Standard Cells
Pre-designed logic gates with:
- Fixed height (typically one or multiple "rows")
- Variable width
- Characterized for timing, power, area
- Examples: AND, OR, NAND, NOR, XOR, flip-flops, buffers

### Netlist
Output of synthesis containing:
- Instances of standard cells
- Net connections between cells
- Port definitions
- Hierarchy (if preserved)

### Constraints (SDC)
Specify design requirements:
- **Clock definition**: Frequency, period
- **Input delays**: When inputs arrive relative to clock
- **Output delays**: When outputs must be stable
- **Timing exceptions**: False paths, multicycle paths
- **Design rules**: Max fanout, max transition, max capacitance

## Synthesis Tools

### Yosys
- Open-source synthesis tool
- Supports Verilog input
- Technology mapping to Liberty (.lib) format
- Used for initial synthesis in this project

### OpenROAD (integrated synthesis)
- Can perform synthesis using Yosys internally
- Integrated with rest of physical design flow
- Better optimization with placement awareness

## Important Metrics

### Timing Metrics
- **Setup time**: Data must be stable before clock edge
- **Hold time**: Data must remain stable after clock edge
- **Clock period**: Determines maximum frequency
- **Slack**: Margin between required and actual timing (positive = good)

### Area Metrics
- **Cell area**: Total area of standard cells
- **Net area**: Area for routing (estimated)
- **Total area**: Cell + routing area

### Power Metrics
- **Dynamic power**: Power consumed during switching
- **Static power**: Leakage power
- **Total power**: Dynamic + static

## Common Issues

### Timing Violations
- **Setup violation**: Path delay too long, data arrives late
- **Hold violation**: Data changes too quickly after clock

**Solutions**:
- Increase clock period (lower frequency)
- Use faster cells
- Optimize critical paths
- Add pipeline stages

### Area Problems
- Design too large for target die size

**Solutions**:
- Use smaller cell variants
- Share resources
- Optimize logic

### Combinational Loops
- Feedback without registers causes instability

**Solutions**:
- Add registers to break loops
- Fix RTL design

## Best Practices

1. **Write synthesizable RTL**
   - Avoid latches (use complete if-else, case statements)
   - Use synchronous resets
   - Avoid combinational loops

2. **Provide realistic constraints**
   - Accurate clock definitions
   - Reasonable input/output delays
   - Don't over-constrain

3. **Check synthesis reports**
   - Review timing reports
   - Check area usage
   - Verify no unmapped cells

4. **Preserve hierarchy (optional)**
   - Helps with debugging
   - Better incremental changes
   - May impact optimization

## Output Files

After synthesis, you will have:
- **Netlist** (.v): Gate-level Verilog
- **Timing reports** (.rpt): Setup/hold analysis
- **Area reports** (.rpt): Cell area breakdown
- **Power reports** (.rpt): Power estimation

## Next Phase

After successful synthesis, the netlist is ready for **Floorplanning** where we define:
- Die/core area
- I/O pin placement
- Macro placement (if any)
- Power grid planning
