# Phase 3: Placement - Theory

## Overview

Placement is the third phase of the Physical Design flow. It assigns physical locations to all standard cells within the core area defined during floorplanning. The goal is to position cells to minimize wirelength, meet timing requirements, and ensure routability.

## What is Placement?

**Placement** is the process of:
- Assigning exact (x, y) coordinates to every standard cell
- Positioning cells within legal placement sites
- Optimizing for wirelength, timing, and congestion
- Preparing the design for clock tree synthesis and routing

This phase transforms cells from abstract instances to physical objects with specific locations on the chip.

## Placement Flow Stages

### Stage 1: Global Placement

**Purpose:** Find approximate cell positions

**Characteristics:**
- Cells can overlap
- Focus on overall wirelength optimization
- Fast, uses analytical methods
- Produces initial placement

**Methods:**
- Quadratic placement
- Analytical optimization
- Force-directed methods
- Considers timing if available

**Output:** Rough cell positions with overlaps

### Stage 2: Detailed Placement

**Purpose:** Legalize and refine cell positions

**Characteristics:**
- Removes all overlaps
- Snaps cells to legal placement sites
- Maintains row alignment
- Enforces design rules

**Methods:**
- Greedy legalization
- Minimum perturbation from global placement
- Row-by-row legalization
- Site snapping

**Output:** Legal, non-overlapping cell positions

### Stage 3: Placement Optimization

**Purpose:** Improve quality metrics

**Characteristics:**
- Timing-driven refinement
- Congestion reduction
- Power optimization
- Cell resizing and buffering

**Methods:**
- Cell swapping
- Cell sliding within rows
- Gate sizing (fast/slow variants)
- Buffer insertion for long nets

**Output:** Optimized legal placement

## Key Concepts

### Placement Sites

**Site Definition:**
- Discrete locations where cells can be placed
- Defined by technology (from LEF file)
- Standard cell height determines row spacing
- Width varies by cell (1x, 2x, 4x site width)

**Site Properties:**
- Name: unithd (Sky130 high density)
- Dimensions: Fixed height, unit width
- Orientation: N (normal) or FS (flipped)
- Symmetry: Cells can flip for power connection

### Legal Placement

A placement is **legal** if:

1. **No Overlaps:**
   - Cells don't overlap with each other
   - Cells don't overlap with blockages

2. **Site Alignment:**
   - Cells snapped to valid placement sites
   - Row alignment maintained
   - Proper orientation

3. **Power Connection:**
   - Cells connect to power rails
   - Alternating row orientation if needed

4. **Design Rules:**
   - Minimum spacing maintained
   - Density limits respected
   - Blockages honored

### Wirelength Optimization

**Half-Perimeter Wirelength (HPWL):**

For a net connecting multiple pins:

    HPWL = (max_x - min_x) + (max_y - min_y)

**Why Minimize Wirelength:**
- Shorter wires → Less delay
- Less routing resource usage
- Lower power consumption
- Better signal integrity

**Trade-offs:**
- Pure wirelength optimization may miss timing
- Must balance with timing constraints
- Consider congestion

### Timing-Driven Placement

**Concept:** Place cells considering timing paths

**Critical Path:**
- Longest delay path in circuit
- Determines maximum frequency
- Must meet timing constraints

**Timing-Driven Strategies:**

1. **Net Weighting:**
   - Critical nets get higher weight
   - Tool tries harder to minimize their length

2. **Path Clustering:**
   - Cells on critical paths placed close
   - Reduces interconnect delay

3. **Buffer Planning:**
   - Long nets get buffers
   - Improves signal integrity and timing

4. **Gate Sizing:**
   - Use faster cells on critical paths
   - Use slower cells elsewhere (save power/area)

### Congestion Management

**Congestion:** Too many wires competing for routing resources

**Causes:**
- High cell density in region
- Many nets crossing same area
- Poor placement distribution

**Congestion Metrics:**
- Routing demand vs. supply per region
- Overflow: Demand exceeds capacity
- Global routing estimation used

**Mitigation:**
- Spread cells more evenly
- Avoid dense clusters
- Route-aware placement
- Adjust utilization

### Placement Quality Metrics

**Wirelength:**
- Total HPWL across all nets
- Lower is better (usually)
- Trade-off with timing

**Timing:**
- Worst negative slack (WNS)
- Total negative slack (TNS)
- Setup and hold timing
- Goal: All positive slack

**Congestion:**
- Maximum overflow
- Average congestion
- Routing difficulty prediction

**Density:**
- Cell distribution uniformity
- Peak density regions
- Should be below routing capacity

**Power:**
- Estimated dynamic power
- Leakage power
- Affected by cell choices and wire lengths

## Placement Algorithms

### Analytical Placement (Global)

**Quadratic Placement:**
- Model placement as spring system
- Nets are springs connecting cells
- Minimize total spring energy
- Fast, good starting point

**Equation:**

    min Σ (weight × wirelength²)

**Properties:**
- Smooth, continuous optimization
- Can produce cell overlaps
- Very fast
- Good for initial placement

### Simulated Annealing

**Concept:** Physical annealing metaphor

**Process:**
1. Start with random placement
2. Iteratively swap/move cells
3. Accept moves that improve cost
4. Accept some bad moves (escape local minima)
5. Gradually reduce acceptance of bad moves

**Properties:**
- Can escape local optima
- Slower than analytical
- Good quality results

### Partitioning-Based

**Concept:** Divide and conquer

**Process:**
1. Partition circuit into subcircuits
2. Assign partitions to regions
3. Recursively partition
4. Place cells within final partitions

**Properties:**
- Hierarchical approach
- Scalable to large designs
- May miss global optimization

## Placement in OpenROAD

OpenROAD uses **RePlAce** (Replace Global Placer):

### Global Placement (RePlAce)

**Command:** `global_placement`

**Features:**
- Analytical quadratic placement
- Timing-driven optimization
- Congestion awareness
- Supports incremental placement

**Parameters:**
- Density: Cell distribution target
- Timing-driven: Enable timing optimization
- Routability: Enable congestion optimization

### Detailed Placement

**Command:** `detailed_placement`

**Features:**
- Legalizes global placement
- Removes overlaps
- Site alignment
- Fast refinement

**Methods:**
- Greedy legalization
- Minimum perturbation
- Local optimization

### Optimization Commands

**improve_placement:**
- Refines placement quality
- Small cell movements
- Timing and congestion aware

**optimize_timing:**
- Gate sizing
- Buffer insertion
- Timing-critical path optimization

## Placement Constraints

### Placement Blockages

**Types:**

1. **Hard Blockages:**
   - No cells allowed
   - Reserved for macros, critical routing

2. **Soft Blockages:**
   - Discourage cell placement
   - Cells allowed if necessary

3. **Partial Blockages:**
   - Density limits
   - Some cells allowed

### Region Constraints

**Usage:** Force cells into specific regions

**Example Use Cases:**
- Keep related logic together
- Separate different power domains
- Cluster high-speed logic
- Isolate noise-sensitive circuits

### Fencing and Guiding

**Fencing:** Restrict cells to a region (must be inside)

**Guiding:** Encourage cells to a region (prefer inside)

## Timing Considerations

### Setup Time

**Definition:** Time before clock edge when data must be stable

**Violation:** Data arrives too late

**Placement Impact:**
- Long paths → Large delays
- Placement determines interconnect delay
- Critical paths need short wirelength

### Hold Time

**Definition:** Time after clock edge when data must remain stable

**Violation:** Data changes too quickly

**Placement Impact:**
- Very short paths may need delay
- Usually fixed with buffers
- Less placement-dependent than setup

### Clock Skew

**Definition:** Difference in clock arrival times

**Causes:**
- Unbalanced clock tree (addressed in CTS)
- Long clock routes
- Placement of flip-flops matters

**Placement Strategy:**
- Group flip-flops when possible
- Minimize clock tree complexity
- Consider clock domains

## Power Considerations

### Dynamic Power

**Formula:**

    P_dynamic = α × C × V² × f

Where:
- α = switching activity
- C = capacitance (related to wirelength)
- V = supply voltage
- f = frequency

**Placement Impact:**
- Shorter wires → Lower C → Lower power
- Critical path cells may need high-power variants
- Non-critical paths can use low-power cells

### Leakage Power

**Source:** Transistor leakage current

**Placement Impact:**
- Cell selection (high-VT vs low-VT)
- Temperature-sensitive
- Density affects temperature

## Common Placement Challenges

### Challenge 1: Congestion Hotspots

**Problem:** Too many wires in one region

**Symptoms:**
- Routing failures
- Long runtime
- Design rule violations

**Solutions:**
- Lower target density
- Spread cells more evenly
- Add routing layers
- Adjust floorplan

### Challenge 2: Timing Violations

**Problem:** Paths don't meet timing

**Symptoms:**
- Negative slack
- Long interconnect delays
- Critical paths too long

**Solutions:**
- Timing-driven placement
- Buffer insertion
- Gate sizing (faster cells)
- Pipeline critical paths

### Challenge 3: Legalization Failures

**Problem:** Can't make placement legal

**Symptoms:**
- Cells don't fit in rows
- Overlaps can't be resolved
- Site conflicts

**Solutions:**
- Increase core area
- Lower target density
- Check for blockages
- Verify cell library

### Challenge 4: High Cell Density

**Problem:** Too many cells in small area

**Symptoms:**
- No room for routing
- Poor quality of results
- Slow tool runtime

**Solutions:**
- Increase utilization target in floorplan
- Larger core area
- Optimize logic (synthesis)
- Remove unnecessary cells

## Placement Quality Checks

### Essential Checks

1. **Legality Check:**
   - All cells non-overlapping
   - Cells on valid sites
   - Design rules met

2. **Timing Check:**
   - Run static timing analysis
   - Check setup and hold
   - Identify critical paths

3. **Congestion Check:**
   - Routing resource availability
   - Overflow analysis
   - Dense regions identification

4. **Density Check:**
   - Cell distribution uniformity
   - Peak density within limits
   - Routing space available

### Visual Inspection

Use OpenROAD GUI to verify:
- Cells placed in rows
- No large empty regions
- Uniform distribution (generally)
- No obvious clustering issues
- Connectivity looks reasonable

## Best Practices

### For Learning

1. **Start with Defaults:**
   - Use standard global placement first
   - Observe results before tuning
   - Understand baseline quality

2. **Incremental Approach:**
   - Global → Detailed → Optimize
   - Check after each stage
   - Don't skip steps

3. **Visual Verification:**
   - Always view placement in GUI
   - Zoom in to see cell details
   - Check for obvious issues

4. **Metrics Tracking:**
   - Record wirelength, timing, congestion
   - Compare different runs
   - Understand trade-offs

### For Production

1. **Timing-Driven:**
   - Always use timing-driven placement
   - Provide accurate constraints
   - Multiple optimization passes

2. **Congestion-Aware:**
   - Enable routability optimization
   - Monitor overflow metrics
   - Adjust if routing will fail

3. **Incremental:**
   - Place incrementally if design changes
   - Preserve good placement when possible
   - Faster turnaround

4. **Quality Targets:**
   - Define acceptable metrics
   - Automate checking
   - Iterate until targets met

## Output Files

After placement:

1. **Updated Database (.odb):**
   - Contains cell locations
   - Ready for CTS
   - All placement information

2. **DEF File:**
   - Placement geometry
   - Can visualize in other tools
   - Standard interchange format

3. **Reports:**
   - Timing analysis
   - Congestion maps
   - Density maps
   - Quality metrics

## Impact on Next Phases

### Phase 4: Clock Tree Synthesis

Placement affects CTS:
- Flip-flop locations determine clock tree
- Placement spread affects skew
- Buffer locations constrained

Good placement → Easier CTS

### Phase 5: Routing

Placement determines routing:
- Wirelength predicts routing demand
- Congestion indicates difficulty
- Cell positions define connectivity

Good placement → Successful routing

### Phase 6: Optimization

Placement quality affects:
- How much timing optimization needed
- Buffer insertion opportunities
- Gate sizing options

Good placement → Less fixing needed

## Summary

Placement assigns physical locations to cells:
- **Global placement:** Find approximate positions
- **Detailed placement:** Legalize positions
- **Optimization:** Refine for quality

Key considerations:
- Wirelength minimization
- Timing closure
- Congestion management
- Power optimization

A good placement:
- Meets timing requirements
- Has reasonable wirelength
- Is routable (no congestion)
- Uses area efficiently

Take time for placement - it's critical for success!

## Next Phase

After placement succeeds, proceed to **Phase 4: Clock Tree Synthesis** where the clock distribution network will be built to deliver the clock signal to all flip-flops.
