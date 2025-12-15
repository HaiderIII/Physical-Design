# Phase 2: Floorplanning - OpenROAD Commands

## Overview

This document covers the essential OpenROAD commands used during the floorplanning phase.

## Reading Design Database

### Load Previous Phase Results

Read the database from synthesis:
    read_db <path_to_synthesis.odb>

Example:
    read_db results/alu_8bit/01_synthesis/alu_8bit.odb

This loads the synthesized netlist with all cells and connectivity.

## Initialize Floorplan

### Method 1: Automatic Sizing (Recommended for Learning)

Let OpenROAD calculate die size based on utilization:

    initialize_floorplan \
      -utilization <percent> \
      -aspect_ratio <ratio> \
      -core_space <margin_um> \
      -site <site_name>

Parameters:
- utilization: Target utilization percentage (e.g., 40 = 40%)
- aspect_ratio: Height/Width ratio (1.0 = square)
- core_space: Margin between core and die edge in microns
- site: Standard cell site name from LEF (e.g., unithd)

Example:
    initialize_floorplan \
      -utilization 40 \
      -aspect_ratio 1.0 \
      -core_space 10 \
      -site unithd

### Method 2: Manual Die/Core Specification

Specify exact dimensions:

    initialize_floorplan \
      -die_area {llx lly urx ury} \
      -core_area {llx lly urx ury} \
      -site <site_name>

Coordinates are in microns:
- llx, lly: Lower-left corner (x, y)
- urx, ury: Upper-right corner (x, y)

Example:
    initialize_floorplan \
      -die_area {0 0 100 100} \
      -core_area {10 10 90 90} \
      -site unithd

### Finding Site Name

Check available sites from technology LEF:
    report_units

Look for SITE definitions in the LEF file, common Sky130 sites:
- unithd: High density standard cell site
- unithddbl: Double-height site

## I/O Pin Placement

### Automatic Pin Placement

Place pins automatically on chip boundary:

    place_pins -hor_layers <metal_layers> -ver_layers <metal_layers>

Parameters:
- hor_layers: Metal layers for horizontal edges (e.g., met3)
- ver_layers: Metal layers for vertical edges (e.g., met2)

Example:
    place_pins -hor_layers met3 -ver_layers met2

This distributes pins evenly around the chip perimeter.

### Advanced Pin Placement Options

Control pin placement more precisely:

    place_pins \
      -hor_layers <layers> \
      -ver_layers <layers> \
      -corner_avoidance <distance> \
      -min_distance <spacing>

Parameters:
- corner_avoidance: Keep pins away from corners (in microns)
- min_distance: Minimum spacing between pins (in microns)

### Manual Pin Constraints

Define regions for specific pins:

    set_io_pin_constraint \
      -pin_names {pin1 pin2 pin3} \
      -region <edge>:<start>-<end>

Edges: top, bottom, left, right
Positions: in microns along edge

Example:
    set_io_pin_constraint \
      -pin_names {clk rst_n} \
      -region left:10-30

Then call place_pins to apply constraints.

### Pin Information Commands

Report pin locations:
    report_pin_placement

List all pins:
    get_ports *

## Standard Cell Rows

### Row Information

After initialize_floorplan, standard cell rows are created automatically.

Check row configuration:
    report_design_area

Rows are horizontal tracks where standard cells will be placed.

Row properties:
- Site: Placement site type (e.g., unithd)
- Orientation: N (normal) or FS (flipped)
- Spacing: Determined by site height

## Tap Cell Insertion

### What are Tap Cells?

Tap cells provide substrate and well connections to prevent latch-up.
Required in CMOS designs for proper operation.

### Insert Tap Cells

    tapcell \
      -tapcell_master <tap_cell_name> \
      -endcap_master <endcap_cell_name> \
      -distance <spacing_sites> \
      -halo_width_x <margin_x> \
      -halo_width_y <margin_y>

Parameters:
- tapcell_master: Tap cell from standard cell library
- endcap_master: End cap cell for row ends
- distance: Spacing between tap cells (in sites)
- halo_width: Margin around tap cells

Sky130 tap cell names:
- Tap cell: sky130_fd_sc_hd__tapvpwrvgnd_1
- End cap: sky130_fd_sc_hd__decap_4 (or similar)

Example:
    tapcell \
      -tapcell_master sky130_fd_sc_hd__tapvpwrvgnd_1 \
      -endcap_master sky130_fd_sc_hd__decap_4 \
      -distance 20 \
      -halo_width_x 2 \
      -halo_width_y 2

Common spacing: 10-25 sites between tap cells.

## Power Distribution Network (PDN)

### PDN Overview

The PDN creates power (VDD) and ground (VSS) distribution:
1. Power rings around core
2. Power stripes across core
3. Standard cell rail connections

### Generate PDN

    pdngen

This command reads PDN configuration and creates the power grid.

### PDN Configuration

OpenROAD uses a PDN configuration script (usually pdngen.tcl).

Basic PDN configuration includes:
- Power net names (VDD, VSS)
- Voltage values
- Metal layers for rings and stripes
- Stripe width and pitch
- Via stacks

Example minimal PDN config:
    pdngen::specify_grid stdcell {
        name grid
        rails {
            met1 {width 0.48 pitch 2.72 offset 0}
        }
        straps {
            met4 {width 1.6 pitch 50.0 offset 2}
            met5 {width 1.6 pitch 50.0 offset 2}
        }
        connect {{met1 met4} {met4 met5}}
    }

For Sky130, standard PDN templates are available.

### Check PDN

Verify PDN connectivity:
    check_power_grid -net VDD
    check_power_grid -net VSS

Report IR drop (after placement):
    analyze_power_grid -net VDD

## Placement Blockages

### Hard Blockages

Prevent cell placement in specific regions:

    create_placement_blockage \
      -name <blockage_name> \
      -bbox {llx lly urx ury}

Example:
    create_placement_blockage \
      -name block1 \
      -bbox {20 20 40 40}

Use for: macros, reserved areas, critical routing.

### Soft Blockages

Discourage but allow placement:

    create_placement_blockage \
      -name <blockage_name> \
      -bbox {llx lly urx ury} \
      -soft

### Remove Blockages

    delete_placement_blockage -name <blockage_name>

## Reporting Commands

### Design Area

Report die and core dimensions:
    report_design_area

Shows:
- Die area (width × height)
- Core area (width × height)
- Utilization

### Cell Information

Count cells and area:
    report_instance

Total cell area:
    report_design_area

This shows how much area cells will occupy.

### Pin Report

List all pins with positions:
    report_pin_placement

### Power Report

After PDN generation:
    report_power_grid

## Visualization Commands

### GUI Commands

If using OpenROAD GUI:

Fit design in view:
    gui::fit

Zoom to specific area:
    gui::zoom_to <llx> <lly> <urx> <ury>

Highlight nets:
    gui::highlight_net <net_name>

Show power grid:
    gui::show_power_grid

## Writing Output Files

### Save Database

Write current state to database:
    write_db <output_file.odb>

Example:
    write_db results/alu_8bit/02_floorplan/alu_8bit_fp.odb

### Write DEF

Export to DEF format:
    write_def <output_file.def>

Example:
    write_def results/alu_8bit/02_floorplan/alu_8bit_fp.def

DEF files can be viewed in other tools like KLayout.

### Write Verilog

Export updated netlist (if modified):
    write_verilog <output_file.v>

## Complete Floorplan Command Sequence

Here is a typical command sequence for floorplanning:

Step 1 - Load design from synthesis:
    read_db results/alu_8bit/01_synthesis/alu_8bit.odb

Step 2 - Initialize floorplan:
    initialize_floorplan \
      -utilization 40 \
      -aspect_ratio 1.0 \
      -core_space 10 \
      -site unithd

Step 3 - Place I/O pins:
    place_pins -hor_layers met3 -ver_layers met2

Step 4 - Insert tap cells:
    tapcell \
      -tapcell_master sky130_fd_sc_hd__tapvpwrvgnd_1 \
      -endcap_master sky130_fd_sc_hd__decap_4 \
      -distance 20

Step 5 - Generate PDN:
    pdngen

Step 6 - Check results:
    report_design_area
    check_power_grid -net VDD
    check_power_grid -net VSS

Step 7 - Save results:
    write_db results/alu_8bit/02_floorplan/alu_8bit_fp.odb
    write_def results/alu_8bit/02_floorplan/alu_8bit_fp.def

## Troubleshooting

### Common Issues and Solutions

**Issue: initialize_floorplan fails with "site not found"**
Solution: Check LEF files loaded, verify site name

**Issue: PDN generation fails**
Solution: Check PDN config, ensure power nets defined

**Issue: Pins overlap or poorly placed**
Solution: Use manual constraints or adjust spacing

**Issue: Utilization too high or too low**
Solution: Adjust -utilization parameter, recalculate

**Issue: Tap cells not inserted**
Solution: Verify tap cell name exists in library

## Best Practices

1. Always check design area after initialize_floorplan
2. Visualize pin placement before proceeding
3. Verify PDN connectivity before next phase
4. Save database after each major step
5. Keep utilization reasonable (40-60% for learning)
6. Use consistent naming for blockages
7. Document any manual constraints applied

## Advanced Topics

### Multiple Power Domains

For designs with multiple voltage domains:
    create_voltage_domain <domain_name> \
      -power <net> -ground <net>

### Macro Placement

For designs with hard macros:
    place_cell <instance_name> <x> <y> -orient <orientation>

### Custom PDN

Write custom PDN configuration script for complex grids.

## Tips for Learning

1. Start with automatic settings
2. Visualize results in GUI after each command
3. Experiment with different utilization values
4. Compare square vs rectangular chips
5. Understand impact on placement area
6. Check power grid visually

## Next Phase Commands

After floorplanning succeeds, proceed to placement:
    global_placement
    detailed_placement

These will be covered in Phase 3: Placement.
