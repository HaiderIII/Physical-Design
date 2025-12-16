# Phase 5: Routing - Theory

## Overview

Routing is the fifth and final phase of the Physical Design flow. It creates the physical wire connections between all cells, completing the layout. Routing transforms the logical netlist into actual metal wires on silicon.

## What is Routing?

**Routing** is the process of:
- Creating physical wire connections between pins
- Using available metal layers and vias
- Following design rules for spacing and width
- Optimizing for timing, area, and manufacturability
- Completing the physical implementation

This phase transforms the design from positioned cells to a complete, manufacturable layout.

## Routing Hierarchy

### Two-Stage Routing

Modern routers use a hierarchical approach:

**Stage 1: Global Routing**
- Plan high-level routes for all nets
- Allocate routing resources (tracks)
- Identify congestion hotspots
- Generate routing guides
- Fast, coarse-grain

**Stage 2: Detailed Routing**
- Complete actual wire geometry
- Follow global routing guides
- Respect design rules exactly
- Resolve DRC violations
- Slower, fine-grain

## Global Routing

### Purpose

Global routing divides the chip into a grid of global routing cells (GCells) and plans which GCells each net will pass through.

### GCell Grid

**GCell Definition:**
- Rectangular region of chip
- Typically 5-20 routing tracks wide
- Spans multiple metal layers
- Has capacity (number of nets it can handle)

**Grid Structure:**

    +-----+-----+-----+-----+
    | GC  | GC  | GC  | GC  |
    +-----+-----+-----+-----+
    | GC  | GC  | GC  | GC  |
    +-----+-----+-----+-----+

### Routing Graph

**Graph Representation:**
- Nodes: GCells
- Edges: Connections between adjacent GCells
- Edge cost: Based on congestion, wirelength
- Capacity: Number of tracks available

### Net Ordering

**Order matters:**
- Critical nets routed first (timing-driven)
- High fanout nets routed early
- Simple nets routed last
- Order affects routability

### Congestion Management

**Congestion:**
- Too many nets competing for same GCell
- Routing demand exceeds capacity
- Leads to routing failures

**Overflow:**
- Number of nets exceeding GCell capacity
- Global router tries to minimize overflow
- May need multiple iterations

**Strategies:**
- Rip-up and reroute congested nets
- Use different layers
- Adjust routing topology
- May need placement changes

### Timing-Driven Global Routing

**Timing Awareness:**
- Critical nets get preferential routing
- Shorter paths for timing-critical signals
- May accept longer routes for non-critical nets
- Balance timing vs. routability

## Detailed Routing

### Purpose

Detailed routing creates the exact wire geometries, specifying:
- Wire center coordinates
- Wire width
- Wire layer
- Via locations and types

### Track Assignment

**Routing Tracks:**
- Predefined locations for wires
- Regular spacing (pitch)
- Direction depends on metal layer
- Defined in technology LEF

**Example:**
- Metal 1: Horizontal, pitch 0.34 µm
- Metal 2: Vertical, pitch 0.34 µm
- Metal 3: Horizontal, pitch 0.46 µm

### Design Rules

Detailed routing must satisfy:

**Spacing Rules:**
- Minimum distance between wires
- Depends on wire width and layer
- Parallel run length affects spacing

**Width Rules:**
- Minimum and maximum wire width
- Default width for signals
- Wider for power/ground

**Via Rules:**
- Via enclosure (metal overlap)
- Via-to-via spacing
- Via array rules

**Density Rules:**
- Maximum metal density per region
- Minimum metal density per region
- For manufacturing uniformity

### DRC Violations

**Design Rule Check (DRC):**
- Verifies layout follows rules
- Detects spacing violations
- Finds width violations
- Checks via enclosure

**Common Violations:**
- Wire too close to another wire
- Wire too narrow
- Via enclosure insufficient
- Off-track routing

**Resolution:**
- Rip-up and reroute violating segment
- Adjust wire width
- Add shielding
- Use different layer

### Search and Connect

**Algorithm:**
- Start from source pin
- Search for path to target pin(s)
- Follow global routing guides
- Use available routing tracks
- Place vias to change layers

**Cost Function:**
- Wirelength
- Via count
- Congestion
- Timing criticality

## Metal Layers

### Layer Stack

Typical technology has multiple metal layers:

    Metal 5 (top)    - Thick, wide, horizontal
    Metal 4          - Medium, vertical
    Metal 3          - Medium, horizontal
    Metal 2          - Thin, vertical
    Metal 1 (bottom) - Thin, horizontal
    
    Cells (polysilicon and diffusion)

### Layer Characteristics

**Lower Metals (M1, M2):**
- Thin wires
- High resistance per micron
- Fine pitch (closely spaced)
- Used for local connections
- Cell-level routing

**Upper Metals (M3-M5):**
- Thick wires
- Low resistance per micron
- Coarse pitch (widely spaced)
- Used for global connections
- Power distribution

### Preferred Direction

**Routing Direction:**
- Alternating layers: H-V-H-V pattern
- Reduces vias (layer changes)
- Simplifies routing algorithm
- Standard practice

**Example Sky130:**
- Metal 1: Horizontal
- Metal 2: Vertical
- Metal 3: Horizontal
- Metal 4: Vertical
- Metal 5: Horizontal

### Vias

**Via Definition:**
- Vertical connection between layers
- Made of metal plug
- Connects two adjacent layers only

**Via Types:**
- Via12: Connects M1 to M2
- Via23: Connects M2 to M3
- Via34: Connects M3 to M4
- etc.

**Via Properties:**
- Resistance: ~1-10 ohms per via
- Adds delay
- Consumes area
- Potential reliability issue

**Via Optimization:**
- Minimize via count (lower resistance)
- Use via arrays for power (redundancy)
- Avoid long via chains

## Routing Objectives

### Primary Goals

1. **100% Connectivity:**
   - Every net must be routed
   - All pins connected
   - No opens (disconnections)

2. **Zero DRC Violations:**
   - All design rules satisfied
   - Manufacturable layout
   - Passes foundry checks

3. **Meet Timing:**
   - Setup and hold timing met
   - Clock requirements satisfied
   - Minimize critical path delay

### Secondary Goals

1. **Minimize Wirelength:**
   - Shorter wires = less delay
   - Less power consumption
   - Less routing resources used

2. **Minimize Vias:**
   - Fewer vias = lower resistance
   - Better reliability
   - Less delay

3. **Uniform Density:**
   - Metal density within limits
   - Avoid hotspots
   - Better manufacturability

4. **Reduce Crosstalk:**
   - Minimize coupling between wires
   - Shield sensitive signals
   - Use spacing and shielding

## Routing Challenges

### Challenge 1: Congestion

**Problem:** Too many nets in one region

**Symptoms:**
- Routing fails to complete
- Many DRC violations
- Long runtimes

**Solutions:**
- Adjust placement (spread cells)
- Use more metal layers
- Reduce utilization
- Manually route critical nets

### Challenge 2: Timing Violations

**Problem:** Routed wires too long, causing delay

**Symptoms:**
- Negative slack after routing
- Setup violations
- Critical paths miss target

**Solutions:**
- Use faster cells on critical paths
- Add buffers to long nets
- Re-optimize placement
- Use upper metal layers (lower R)

### Challenge 3: DRC Violations

**Problem:** Design rules not satisfied

**Symptoms:**
- Spacing violations
- Width violations
- Via problems

**Solutions:**
- Rip-up and reroute
- Adjust wire width
- Fix via enclosure
- Use detailed router cleanup

### Challenge 4: Crosstalk

**Problem:** Signal coupling between wires

**Symptoms:**
- Signal integrity issues
- Timing uncertainty
- Functional failures

**Solutions:**
- Increase spacing
- Use shielding (ground wires)
- Route on different layers
- Add decoupling

### Challenge 5: IR Drop

**Problem:** Voltage drop on power grid

**Symptoms:**
- Cell performance degradation
- Timing failures
- Possible functional issues

**Solutions:**
- Widen power wires
- Add more power stripes
- Use upper metals for power
- Verify power grid early

## Routing Algorithms

### Maze Routing (Lee's Algorithm)

**Concept:**
- Wave propagation from source
- Find shortest path to target
- Guarantees shortest path if exists

**Process:**
1. Label source = 0
2. Label adjacent cells = 1
3. Expand wave until target reached
4. Trace back path

**Advantages:**
- Finds optimal path
- Complete algorithm

**Disadvantages:**
- Very slow for large designs
- High memory usage
- Not practical for full chip

### A* Search

**Concept:**
- Heuristic-guided search
- Prioritize promising directions
- Much faster than maze routing

**Heuristic:**
- Manhattan distance to target
- Guides search efficiently
- Still finds good paths

**Advantages:**
- Much faster than maze
- Good path quality
- Practical for large designs

**Disadvantages:**
- May not find absolute shortest
- Depends on heuristic quality

### Pattern Routing

**Concept:**
- Use pre-defined routing patterns
- Common for power/ground
- Fast and predictable

**Examples:**
- Power rings
- Power stripes
- Clock tree routing

### Steiner Tree

**Problem:**
- Route multi-pin net optimally
- Minimize total wirelength
- NP-hard problem

**Heuristics:**
- Minimum Spanning Tree (MST)
- Rectilinear Steiner Tree (RST)
- Various approximations

**Trade-offs:**
- Shorter total wire vs. delay
- Balanced tree vs. minimum wire
- Runtime vs. quality

## Parasitic Extraction

### Purpose

After routing, extract:
- Wire resistance (R)
- Wire capacitance (C)
- Coupling capacitance (Cc)

### RC Parasitics

**Resistance:**
- R = ρ × L / (W × T)
- ρ: Resistivity of metal
- L: Wire length
- W: Wire width
- T: Metal thickness

**Capacitance:**
- C_ground: Capacitance to substrate/ground
- C_coupling: Capacitance to adjacent wires
- C_total = C_ground + C_coupling

### Impact on Timing

**Delay:**
- Wire delay = f(R, C)
- RC delay increases with length
- Affects timing analysis

**Slew:**
- Transition time increases
- Slow edges cause timing uncertainty
- May violate slew limits

**Crosstalk:**
- Coupling causes noise
- Can cause functional errors
- Affects timing (delta delay)

### Extraction Tools

**Levels of Extraction:**
- Lumped RC: Single R, single C
- Distributed RC: RC network
- Full 3D extraction: Accurate but slow

## Timing After Routing

### Post-Route Timing

**More Accurate:**
- Uses extracted parasitics
- Real wire delays included
- Most accurate timing yet

**Common Issues:**
- Setup violations (wires too long)
- Hold violations (too much clock skew)
- Slew violations (slow transitions)

### Timing Closure

**If timing fails:**
1. Analyze critical paths
2. Identify bottlenecks
3. Apply fixes:
   - Buffer insertion
   - Gate sizing
   - Re-routing
   - Placement adjustment

**Iteration:**
- May need multiple routing passes
- Optimize critical paths
- Balance timing and area

## Routing in OpenROAD

OpenROAD uses **TritonRoute** for detailed routing:

**Features:**
- Industry-standard algorithm
- DRC-aware routing
- Timing-driven optimization
- Fast runtime

**Flow:**
1. Load design with CTS
2. Run global routing
3. Run detailed routing
4. Fix DRC violations
5. Extract parasitics
6. Verify timing

**Commands:**
- global_route: Plan routes
- detailed_route: Complete routing
- check_antennas: Verify antenna rules
- write_db: Save routed design

## Special Nets

### Power and Ground

**Already Routed:**
- PDN created in floorplanning
- Power stripes in place
- Power rails in rows

**Routing Connects:**
- Cells to power rails
- Signals routed around power

### Clock Nets

**Already Routed:**
- CTS routes clock tree
- Clock buffers connected
- Balanced clock distribution

**Routing Handles:**
- Non-clock signals
- Data paths
- Control signals

### Signal Nets

**What Gets Routed:**
- All combinational logic signals
- Data paths between FFs
- Control signals
- I/O connections

## Design Rule Checking (DRC)

### Common Rules

**Spacing:**
- Metal-to-metal minimum spacing
- Same net vs. different net rules
- Depends on wire widths

**Width:**
- Minimum wire width
- Maximum wire width (for current)
- Via widths

**Enclosure:**
- Via must be enclosed by metal
- Minimum overlap required
- Ensures connection

**Density:**
- Min/max metal density per region
- For chemical-mechanical polishing
- Affects manufacturability

### Verification

**After Routing:**
- Run DRC check
- Fix any violations
- Iterate until clean

## Best Practices

### For Learning

1. **Start Simple:**
   - Use default router settings
   - Analyze results
   - Understand routing quality

2. **Check Connectivity:**
   - Verify all nets routed
   - Check for opens
   - Visual inspection in GUI

3. **Review Timing:**
   - Compare pre- and post-route
   - Understand wire delay impact
   - Learn timing closure

4. **Study DRC:**
   - Understand violations
   - Learn design rules
   - See how router fixes issues

### For Production

1. **Plan for Routability:**
   - Keep utilization reasonable
   - Good placement helps routing
   - Avoid congestion hotspots

2. **Timing-Driven:**
   - Enable timing-driven routing
   - Provide accurate constraints
   - Prioritize critical paths

3. **Iterate:**
   - First pass may not be clean
   - Fix violations incrementally
   - May need placement tweaks

4. **Verify Thoroughly:**
   - DRC clean
   - LVS clean (connectivity)
   - Timing met
   - Power integrity verified

## Output Files

After routing:

1. **Routed Database (.odb):**
   - Complete physical design
   - All wires and vias
   - Ready for signoff

2. **DEF File:**
   - Routed geometry
   - Can view in layout viewers
   - Standard format

3. **GDSII (optional):**
   - Final layout format
   - Sent to foundry
   - Manufacturing data

4. **Reports:**
   - Routing statistics
   - DRC report
   - Timing report
   - Congestion map

## Impact on Final Design

Routing is the last major step:
- Physical design is complete
- Layout is final
- Ready for verification
- Can proceed to signoff

**Remaining Steps:**
- Design rule verification (DRC)
- Layout vs. Schematic (LVS)
- Timing signoff (STA)
- Power analysis
- Signal integrity checks

## Summary

Routing creates physical wire connections:
- **Global routing:** Plan high-level routes
- **Detailed routing:** Complete exact geometry
- **DRC clean:** All design rules satisfied
- **Timing met:** Performance targets achieved

Key considerations:
- Connectivity (100% routed)
- Design rules (zero violations)
- Timing closure
- Manufacturability

A successful routing:
- All nets connected
- DRC clean
- Timing met
- Ready for manufacturing

Take time for routing - it completes the design!

## Next Phase

After routing succeeds, the physical design is complete. The next steps are verification and signoff:
- DRC verification
- LVS verification
- Timing signoff
- Power analysis
- Ready for tape-out
