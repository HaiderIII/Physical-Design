# Phase 4: Clock Tree Synthesis - Theory

## Overview

Clock Tree Synthesis (CTS) is the fourth phase of the Physical Design flow. It builds a clock distribution network to deliver the clock signal from the clock source to all sequential elements (flip-flops, latches) with minimal skew and acceptable latency.

## What is Clock Tree Synthesis?

**Clock Tree Synthesis** is the process of:
- Building a hierarchical clock distribution network
- Inserting clock buffers to drive the clock signal
- Balancing path delays to minimize skew
- Optimizing for power, area, and timing
- Ensuring proper clock signal integrity

This phase is critical because the clock is the most important signal in synchronous digital designs - any clock issues directly impact timing and functionality.

## Key Concepts

### Clock Signal

**The Clock:**
- Periodic signal that synchronizes sequential logic
- Triggers state changes in flip-flops
- Must reach all sequential elements reliably
- Typically the highest fanout net in design

**Clock Properties:**
- **Period (T):** Time for one complete cycle
- **Frequency (f):** 1/T (e.g., 50 MHz = 20 ns period)
- **Duty Cycle:** Percentage of time clock is high
- **Edge:** Rising or falling transition

### Sequential Elements

**Flip-Flops:**
- Store state in synchronous designs
- Triggered by clock edge (rising or falling)
- Our ALU has 11 flip-flops for result and flags
- Clock must reach all FFs at nearly the same time

**Clock Pins:**
- Input pin where clock connects to FF
- Also called "clock sink" or "clock endpoint"
- CTS goal: deliver clock to all sinks

### Clock Skew

**Definition:** Difference in clock arrival times between two sequential elements

    Skew = |Arrival_Time(FF1) - Arrival_Time(FF2)|

**Types:**

1. **Local Skew:**
   - Between two specific flip-flops
   - Matters for paths between these FFs
   - Critical for timing analysis

2. **Global Skew:**
   - Maximum skew across all FFs
   - Overall clock distribution quality
   - Design specification metric

**Impact on Timing:**

For a path from FF1 to FF2:
- **Positive skew:** Clock arrives at FF2 later (helps setup, hurts hold)
- **Negative skew:** Clock arrives at FF2 earlier (hurts setup, helps hold)
- **Zero skew:** Ideal but impossible in practice

**Skew Budget:**
- Typical target: < 5-10% of clock period
- For 20ns period: skew < 1-2 ns
- Tighter skew = easier timing closure
- But costs power and area (more buffers)

### Clock Latency

**Definition:** Delay from clock source to clock sink

    Latency = Arrival_Time(Sink) - Source_Time

**Components:**

1. **Source Latency:**
   - Delay before clock enters the chip
   - PLL, clock generation, package
   - Usually specified, not designed

2. **Network Latency:**
   - Delay through on-chip clock tree
   - Buffers and wires
   - What CTS controls

**Impact:**
- Latency itself doesn't hurt timing (affects all FFs equally)
- But excessive latency wastes power
- Long wires increase skew risk
- Balance: minimize latency, control skew

### Clock Tree Structure

**Tree Topology:**

A clock tree is hierarchical:

    Clock Source (root)
         |
    ----+----
    |       |
  Buffer  Buffer  (Level 1)
    |       |
  --+--   --+--
  |   |   |   |
 FF  FF  FF  FF  (Sinks/leaves)

**Levels:**
- Root: Clock source
- Internal nodes: Clock buffers
- Leaves: Clock sinks (FF clock pins)

**Balance:**
- All paths from root to leaves should have similar delays
- Achieved by buffer insertion and wire sizing
- Balancing reduces skew

### Clock Buffers

**Purpose:**
- Drive large clock fanout (many FFs)
- Reduce wire delay and transition time
- Enable hierarchical distribution
- Isolate different clock branches

**Buffer Properties:**
- **Drive Strength:** Ability to charge capacitance
- **Delay:** Propagation delay through buffer
- **Power:** Larger buffers consume more power
- **Size:** Area cost

**Buffer Insertion Strategy:**
- More buffers = lower skew, higher power
- Fewer buffers = higher skew, lower power
- Tool balances based on constraints

### Clock Tree Styles

**H-Tree:**
- Symmetric H-shaped structure
- Good for uniform FF distribution
- Minimizes skew naturally
- May not suit irregular layouts

**Binary Tree:**
- Each buffer drives two sub-trees
- Flexible for any FF placement
- Easy to balance
- Most common approach

**Mesh/Grid:**
- Clock distributed via grid structure
- Redundant paths reduce skew
- Higher power consumption
- Used in high-performance designs

**Hybrid:**
- Combines tree and mesh
- Tree for global distribution
- Local mesh for critical regions
- Balance power and performance

## Clock Tree Synthesis Flow

### Step 1: Clock Tree Specification

Define clock tree requirements:

**Clock Definitions:**
- Clock source (port or pin)
- Clock period and frequency
- Clock domain (if multiple clocks)

**Skew Targets:**
- Maximum global skew
- Local skew for critical paths
- Skew group definitions

**Constraints:**
- Maximum latency
- Maximum transition time
- Maximum capacitance
- Buffer restrictions

### Step 2: Clustering

Group nearby flip-flops:

**Purpose:**
- Reduce problem complexity
- Create hierarchical structure
- Enable local optimization

**Methods:**
- Geometric clustering (proximity)
- Electrical clustering (timing)
- Capacity-based (buffers per cluster)

### Step 3: Buffer Insertion

Insert clock buffers in tree:

**Bottom-Up Approach:**
- Start with FF clusters
- Insert buffers to drive each cluster
- Recursively build tree upward
- Connect to clock source

**Considerations:**
- Buffer drive strength
- Fanout limits
- Wire delay
- Skew targets

### Step 4: Tree Balancing

Balance delays in tree:

**Techniques:**
- Buffer sizing (adjust drive strength)
- Wire sizing (change wire width)
- Buffer relocation
- Dummy buffer insertion (for delay)

**Goal:** Equal delay from source to all sinks

### Step 5: Clock Routing

Route the clock tree:

**Special Routing:**
- Often uses dedicated clock routing layers
- Shielded to reduce noise
- Wider wires for lower resistance
- Symmetrical when possible

**NDR (Non-Default Rules):**
- Special design rules for clock
- Wider spacing (reduce crosstalk)
- Wider wires (reduce resistance)
- Via redundancy

### Step 6: Optimization

Refine clock tree:

**Objectives:**
- Minimize skew
- Reduce latency
- Minimize power
- Meet all constraints

**Methods:**
- Buffer sizing optimization
- Tree restructuring
- Gate cloning
- Useful skew insertion

## Useful Skew

**Concept:** Intentionally introduce skew to help timing

**Traditional Approach:**
- Zero skew is ideal
- Minimize skew everywhere

**Useful Skew Approach:**
- Some skew can help timing
- Positive skew helps setup timing
- Negative skew helps hold timing
- Optimize skew for each path

**Example:**

For path FF1 to FF2 with setup violation:
- Make clock arrive at FF2 slightly later
- Gives more time for data propagation
- Trades setup margin for hold margin

**Benefits:**
- Can fix timing violations
- Reduce need for gate sizing
- Lower power (fewer optimizations needed)

**Caution:**
- Must verify all paths
- Can create hold violations
- Requires careful analysis

## Clock Gating

**Purpose:** Reduce dynamic power by stopping clock when not needed

**Concept:**

    Clock goes to Gate, then to FF
    Gate is controlled by Enable signal
    When Enable = 0, clock is blocked

When Enable = 0, clock is blocked, FF doesn't switch, saves power.

**Types:**

1. **Latch-Based:**
   - Uses latch to hold enable signal
   - Prevents glitches
   - Industry standard

2. **AND/OR-Based:**
   - Simple logic gate
   - May have glitches
   - Requires careful design

**CTS with Clock Gating:**
- Gating cells treated as clock tree elements
- Must balance delays through gating cells
- Enable logic must meet timing

**Benefits:**
- Significant power reduction (20-40%)
- No functionality change
- Can gate entire modules

## Clock Tree Quality Metrics

### Skew

**Global Skew:**

    Global Skew = max(Latency) - min(Latency)

Target: < 5-10% of period

**Local Skew:**

Skew between specific FF pairs on critical paths

### Latency

**Average Latency:**

Sum of all sink latencies / number of sinks

**Maximum Latency:**

Longest path from source to any sink

Target: Minimize while meeting skew

### Transition Time

**Clock Edge Transition:**
- Rise time and fall time at each sink
- Slow transitions cause timing uncertainty
- Fast transitions increase power

Target: 10-20% of clock period

### Insertion Delay

**Source to Sink Delay:**
- Total delay from clock source to FF
- Includes all buffers and wires

Related to latency but measured from actual source

### Power

**Dynamic Power:**

    P_clock = α × C_clock × V² × f

Where:
- α = switching activity (clock = 1.0, always switching)
- C_clock = total clock network capacitance
- V = supply voltage
- f = clock frequency

**Components:**
- Buffer power (proportional to buffer count/size)
- Wire power (proportional to wire capacitance)

**Optimization:**
- Use minimum buffer sizes that meet skew
- Minimize wire length
- Use clock gating

### Duty Cycle

**Definition:** Percentage of period clock is high

Ideal: 50%

Variations cause:
- Skew between rise and fall edges
- Timing margin reduction
- Possible functional issues

## Common CTS Challenges

### Challenge 1: High Skew

**Problem:** Skew exceeds target

**Causes:**
- Unbalanced clock tree
- Long wires
- Insufficient buffering
- Poor FF placement

**Solutions:**
- Add more buffers
- Increase buffer sizes
- Rebalance tree structure
- Consider useful skew
- Improve placement

### Challenge 2: High Latency

**Problem:** Excessive clock delay

**Causes:**
- Too many buffer levels
- Oversized buffers
- Long routing paths

**Solutions:**
- Reduce buffer levels
- Use smaller buffers (if skew allows)
- Optimize tree topology
- Shorter clock routes

### Challenge 3: Congestion

**Problem:** Clock routing causes congestion

**Causes:**
- Clock uses too many routing resources
- Conflicts with signal routing
- Clock tree too complex

**Solutions:**
- Use fewer buffers if possible
- Optimize clock routing layers
- Adjust buffer placement
- Coordinate with signal routing

### Challenge 4: Transition Time

**Problem:** Slow clock edges

**Causes:**
- Undersized buffers
- High capacitive load
- Long wires

**Solutions:**
- Increase buffer drive strength
- Add intermediate buffers
- Reduce wire capacitance
- Shorten wire segments

### Challenge 5: Hold Violations

**Problem:** Hold timing fails after CTS

**Causes:**
- Clock arrives too early at destination FF
- Short data paths
- Negative skew

**Solutions:**
- Add delay cells on data path
- Adjust clock tree (useful skew)
- Buffer insertion on data path
- May need placement changes

## CTS in OpenROAD

OpenROAD uses **TritonCTS** for clock tree synthesis:

**Features:**
- Hierarchical tree building
- Buffer insertion and sizing
- Skew optimization
- Latency minimization
- Integration with placement

**Flow:**
1. Define clock nets
2. Specify buffer list
3. Set skew/latency targets
4. Run CTS
5. Analyze results
6. Optimize if needed

**Commands:**
- `clock_tree_synthesis`: Main CTS command
- `set_wire_rc`: Wire parasitics (already done)
- `report_clock_skew`: Check skew results
- `report_clock_latency`: Check latency (not available in all versions)

## Timing Analysis After CTS

**Pre-CTS vs Post-CTS:**

**Before CTS:**
- Clock assumed ideal (zero delay, zero skew)
- Conservative timing analysis
- May show better timing than reality

**After CTS:**
- Real clock delays included
- Actual skew accounted for
- More accurate timing
- May reveal new violations

**Setup Timing:**

    Required Time = Period - Skew - Setup_Time
    Slack = Required Time - Arrival Time

Positive skew helps setup (more time).

**Hold Timing:**

    Required Time = Hold_Time + Skew
    Slack = Arrival Time - Required Time

Positive skew hurts hold (less time).

**Critical:** Must check both setup and hold after CTS!

## Best Practices

### For Learning

1. **Start Simple:**
   - Use default CTS settings first
   - Analyze results
   - Understand baseline

2. **Check Skew:**
   - Always report skew after CTS
   - Compare to targets
   - Understand skew distribution

3. **Verify Timing:**
   - Run full timing analysis post-CTS
   - Check setup and hold
   - Compare with pre-CTS

4. **Visualize:**
   - View clock tree in GUI
   - See buffer placement
   - Check tree structure

### For Production

1. **Define Constraints:**
   - Clear skew targets
   - Latency limits
   - Transition time specs
   - Power budget

2. **Buffer Selection:**
   - Choose appropriate buffer list
   - Mix of sizes for flexibility
   - Consider power vs. performance

3. **Iterate:**
   - CTS often needs multiple runs
   - Adjust constraints based on results
   - Balance skew, latency, power

4. **Coordinate with Routing:**
   - Clock routing impacts signal routing
   - May need routing-aware CTS
   - Iterate CTS and routing if needed

## Output Files

After CTS:

1. **Updated Database (.odb):**
   - Includes clock buffers
   - Clock tree structure
   - Ready for routing

2. **DEF File:**
   - Physical design with CTS
   - Can visualize clock tree
   - Interchange format

3. **Reports:**
   - Clock skew report
   - Clock latency report
   - Timing analysis (post-CTS)
   - Buffer count and types

## Impact on Next Phases

### Phase 5: Routing

CTS affects routing:
- Clock nets already routed (or reserved)
- More buffers = more cells to connect
- Clock routing may create congestion
- Signal routing must work around clock

Good CTS → Manageable routing

### Phase 6: Timing Closure

CTS affects final timing:
- Real clock delays now included
- Skew impacts setup/hold
- May reveal new violations
- Further optimization may be needed

Good CTS → Easier timing closure

## Summary

Clock Tree Synthesis builds the clock distribution network:
- **Insert buffers:** Drive clock signal
- **Balance delays:** Minimize skew
- **Optimize:** Meet latency, power goals
- **Route:** Complete clock connections

Key considerations:
- Skew minimization (< 5-10% of period)
- Latency optimization
- Power consumption
- Timing impact (setup/hold)

A good clock tree:
- Low skew (< target)
- Reasonable latency
- Efficient power usage
- Enables timing closure

Take time for CTS - clock quality is critical!

## Next Phase

After CTS succeeds, proceed to **Phase 5: Routing** where all signal nets will be routed, completing the physical connections between cells.
