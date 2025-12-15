# Phase 2: Floorplanning - Theory

## Overview

Floorplanning is the second phase of the Physical Design flow. It defines the physical boundaries of the chip, positions I/O pins, plans the power distribution network, and prepares the design for standard cell placement.

## What is Floorplanning?

**Floorplanning** is the process of:
- Defining the chip dimensions (die size and core area)
- Placing I/O pins on the chip boundary
- Planning macro placement (if any large blocks exist)
- Creating the power distribution network (PDN)
- Setting up placement blockages and regions

This phase transforms the abstract netlist into a physical space where cells will eventually be placed.

## Key Concepts

### Die vs Core

**Die Area:**
- The entire silicon area including I/O pads and seal ring
- Outer boundary of the physical chip
- Contains everything: core, I/O, power rings

**Core Area:**
- The region where standard cells will be placed
- Inside the die, surrounded by I/O and power structures
- Utilization is calculated based on core area

**Core-to-Die Ratio:**
- Typical values: 0.6 to 0.9
- Smaller ratio = more space for I/O and power
- Larger ratio = denser design, less routing space

### Utilization

**Definition:** Percentage of core area occupied by standard cells

    Utilization = (Total Cell Area / Core Area) × 100%

**Typical Values:**
- 40-60% for initial placement (leaves routing space)
- 70-80% for dense designs
- Higher utilization = less routing resources, harder timing closure

**Our ALU Design:**
- Cell Area: 1485 µm²
- Target Utilization: 40-50% (good for learning)
- Required Core Area: ~3000-3700 µm²

### Aspect Ratio

**Definition:** Ratio of height to width of the chip

    Aspect Ratio = Height / Width

**Common Values:**
- 1.0 = Square chip (most common)
- 0.5 = Wider chip (2:1)
- 2.0 = Taller chip (1:2)

**Considerations:**
- Square chips easier for power distribution
- Rectangular chips may suit specific applications
- Affects wire lengths and routability

### I/O Pin Placement

**Purpose:** Position input and output pins on chip boundary

**Strategies:**
1. **Automatic Placement:**
   - Tool places pins based on connectivity
   - Minimizes wire lengths to connected cells
   - Good starting point

2. **Manual Placement:**
   - Designer specifies exact pin positions
   - Needed for specific package requirements
   - Better control for critical signals

3. **Constraint-Based:**
   - Define regions or layers for pins
   - Tool places within constraints
   - Balance between control and automation

**Pin Layers:**
- Typically on metal layers (met2, met3)
- Must align with package pin assignments
- Consider signal integrity and routing

### Power Planning

**Power Distribution Network (PDN):**

The PDN delivers power (VDD) and ground (VSS) to all cells:

1. **Power Pads:**
   - Entry points for VDD/VSS from package
   - Multiple pads for current distribution

2. **Power Rings:**
   - Metal rings around core periphery
   - Wide to carry large currents
   - Usually on top metal layers

3. **Power Stripes:**
   - Vertical and horizontal metal lines
   - Cross the core area
   - Connect to rings and standard cell rows

4. **Standard Cell Rails:**
   - VDD/VSS rails in each cell row
   - Cells connect directly to rails
   - Typically on metal1

**Power Grid Strategy:**
- Minimize IR drop (voltage drop across metal)
- Reduce electromigration risk
- Ensure all cells have good power connection

### Placement Blockages

**Types:**

1. **Hard Blockages:**
   - No cells can be placed
   - Used for: macros, reserved areas, critical routing

2. **Soft Blockages:**
   - Cells discouraged but allowed if needed
   - Used for: preferred routing channels

3. **Partial Blockages:**
   - Limited cell density allowed
   - Used for: congestion management

## Floorplanning Flow Steps

### Step 1: Initialize Floorplan

Define basic chip parameters:
- Die size (or let tool calculate based on utilization)
- Core-to-die margins
- Aspect ratio
- Utilization target

**OpenROAD Command:**

    initialize_floorplan \
      -die_area {x1 y1 x2 y2} \
      -core_area {x1 y1 x2 y2} \
      -site <site_name>

Or use automatic sizing:

    initialize_floorplan \
      -utilization <percent> \
      -aspect_ratio <ratio> \
      -core_space <margin>

### Step 2: Place I/O Pins

Position pins on chip boundary:

**Automatic:**

    place_pins -hor_layers <layers> -ver_layers <layers>

**Manual:**

    set_io_pin_constraint -pin_names {pin1 pin2} -region <region>

### Step 3: Insert Tap Cells

**Tap cells** provide substrate/well connections:
- Required for proper transistor operation
- Placed at regular intervals
- Connect to power rails

    tapcell \
      -tapcell_master <cell_name> \
      -endcap_master <cell_name> \
      -distance <spacing> \
      -halo_width_x <value> \
      -halo_width_y <value>

### Step 4: Power Distribution Network

Create the PDN structure:

    pdngen \
      -verbose

This uses PDN configuration file specifying:
- Power ring dimensions
- Stripe width and spacing
- Via rules
- Connection strategy

### Step 5: Verify Floorplan

Check for issues:
- Die/core area reasonable
- Pins placed correctly
- No overlapping structures
- PDN properly connected

## Important Metrics

### Area Metrics

**Die Area:**

    Die Area = Die Width × Die Height

**Core Area:**

    Core Area = Core Width × Core Height

**Utilization:**

    Utilization = Cell Area / Core Area

### Power Metrics

**IR Drop:**
- Voltage drop from pad to cell
- Target: < 5% of supply voltage
- Depends on wire resistance and current

**Electromigration:**
- Current density limits in metal
- Depends on metal layer and width
- Tool checks during PDN creation

### Placement Metrics

**Available Sites:**
- Number of standard cell rows
- Each row has placement sites
- Determines maximum cell capacity

**Row Spacing:**
- Distance between cell rows
- Allows routing channels
- Affects chip height

## Common Floorplanning Challenges

### Challenge 1: Utilization vs Routability

**Problem:**
- High utilization saves area but leaves little routing space
- Low utilization wastes area but eases routing

**Solution:**
- Start with 40-50% for complex designs
- Increase incrementally if routing succeeds
- Monitor congestion during placement

### Challenge 2: Pin Placement

**Problem:**
- Poor pin placement increases wire lengths
- Can create routing congestion
- May not match package requirements

**Solution:**
- Use automatic placement as starting point
- Manually adjust critical pins
- Consider signal grouping (buses together)

### Challenge 3: Power Distribution

**Problem:**
- Insufficient PDN causes IR drop violations
- Excessive PDN wastes area and blocks routing

**Solution:**
- Follow PDK recommendations
- Calculate current requirements
- Use multiple power domains if needed

### Challenge 4: Aspect Ratio Selection

**Problem:**
- Wrong aspect ratio complicates layout
- May not fit package

**Solution:**
- Start with square (1.0) for simplicity
- Adjust based on pin requirements
- Consider routing direction preferences

## Floorplan Quality Checks

### Essential Checks

1. **Area Check:**
   - Core area sufficient for cells + routing
   - Utilization in acceptable range (40-70%)

2. **Pin Check:**
   - All pins placed on valid layers
   - Pins accessible for routing
   - No overlapping pins

3. **Power Check:**
   - PDN covers entire core
   - All cells can connect to power
   - IR drop acceptable

4. **Spacing Check:**
   - Adequate space between structures
   - Meets design rules
   - Room for routing

### Visual Inspection

Use OpenROAD GUI to verify:
- Die/core boundaries look reasonable
- Pins evenly distributed (or as desired)
- Power grid visible and complete
- No obvious errors

## Best Practices

### For Learning

1. **Start Simple:**
   - Use automatic features first
   - Square chip, moderate utilization
   - Automatic pin placement

2. **Understand Parameters:**
   - Experiment with utilization (30%, 50%, 70%)
   - Try different aspect ratios
   - See impact on design

3. **Check Each Step:**
   - Visualize after each command
   - Verify before proceeding
   - Learn from mistakes

### For Production

1. **Follow Standards:**
   - Use company/project guidelines
   - Consistent naming conventions
   - Document decisions

2. **Plan Ahead:**
   - Consider routing needs
   - Plan for design changes
   - Leave margin for optimization

3. **Iterate:**
   - Floorplan affects all later stages
   - May need to revisit after placement
   - Balance area, timing, power

## Output Files

After floorplanning:

1. **Updated Database (.odb):**
   - Contains floorplan information
   - Die/core dimensions
   - Pin positions
   - PDN structure

2. **DEF File:**
   - Design Exchange Format
   - Floorplan geometry
   - Can be viewed in other tools

3. **Reports:**
   - Area report
   - Power report
   - Pin list

## Impact on Next Phases

### Phase 3: Placement

Floorplan directly affects:
- Where cells can be placed (core area)
- Row structure for cells
- Blockages to avoid
- Power connections available

Good floorplan = easier placement

### Phase 4: Clock Tree Synthesis

Floorplan impacts:
- Clock pin locations
- Clock tree structure
- Skew management

### Phase 5: Routing

Floorplan determines:
- Available routing resources
- Congestion potential
- Power grid connectivity

## Summary

Floorplanning establishes the physical foundation for the chip:
- Defines boundaries and areas
- Positions I/O pins
- Creates power distribution
- Prepares for cell placement

A good floorplan:
- Balances area and routability
- Facilitates power delivery
- Enables efficient placement
- Sets up successful routing

Take time to get floorplanning right - it affects everything that follows!

## Next Phase

After floorplanning, proceed to **Phase 3: Placement** where standard cells will be positioned within the core area defined here.
