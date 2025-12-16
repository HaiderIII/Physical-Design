# TCL Fundamentals - Part 3: OpenROAD API

> 🎯 **Objective**: Learn how to interact with OpenROAD's database using TCL commands to query and manipulate your design.

---

## 1. OpenROAD Basics

### Starting OpenROAD

```bash
# Interactive mode
openroad

# Run a script
openroad script.tcl

# Run script and stay interactive
openroad -gui script.tcl
```

### Loading a Design

The typical flow to load a design:

```tcl
# 1. Read technology LEF (layer definitions)
read_lef /path/to/tech.lef

# 2. Read library LEF (cell definitions)
read_lef /path/to/cells.lef

# 3. Read Liberty (timing information)
read_liberty /path/to/cells.lib

# 4. Read Verilog netlist
read_verilog /path/to/design.v

# 5. Link the design (connect everything)
link_design top_module_name
```

### Complete Example with Nangate45

```tcl
# Set paths
set pdk_dir "/path/to/nangate45"

# Read LEF files
read_lef $pdk_dir/lef/NangateOpenCellLibrary.tech.lef
read_lef $pdk_dir/lef/NangateOpenCellLibrary.lef

# Read Liberty
read_liberty $pdk_dir/lib/NangateOpenCellLibrary_typical.lib

# Read design
read_verilog ./results/synthesized.v
link_design counter

puts "Design loaded successfully!"
```

---

## 2. Querying Design Objects

OpenROAD uses the OpenDB database. You can query cells, nets, pins, and more.

### Getting Cells

```tcl
# Get all cells in the design
set all_cells [get_cells *]
puts "Total cells: [llength $all_cells]"

# Get cells matching a pattern
set ff_cells [get_cells *reg*]
puts "Flip-flop cells: [llength $ff_cells]"

# Get a specific cell
set my_cell [get_cells U123]
```

### Getting Nets

```tcl
# Get all nets
set all_nets [get_nets *]
puts "Total nets: [llength $all_nets]"

# Get clock nets
set clk_nets [get_nets *clk*]

# Get a specific net
set my_net [get_nets data_bus[0]]
```

### Getting Pins

```tcl
# Get all pins of a cell
set cell_pins [get_pins U123/*]

# Get input pins only
set input_pins [get_pins -filter "direction == input" U123/*]

# Get clock pins
set clk_pins [get_pins */CLK]
```

### Getting Ports (Top-level I/O)

```tcl
# Get all ports
set all_ports [get_ports *]

# Get input ports
set inputs [get_ports -filter "direction == input" *]

# Get output ports
set outputs [get_ports -filter "direction == output" *]

# Get clock port
set clk_port [get_ports clk]
```

---

## 3. Iterating Over Design Objects

### Using `foreach` with Design Objects

```tcl
# Iterate over all cells
foreach cell [get_cells *] {
    set cell_name [get_name $cell]
    set cell_type [get_property $cell ref_name]
    puts "Cell: $cell_name, Type: $cell_type"
}
```

### Filtering While Iterating

```tcl
# Find all buffer cells
set buffer_count 0
foreach cell [get_cells *] {
    set ref_name [get_property $cell ref_name]
    if {[string match "BUF_*" $ref_name]} {
        incr buffer_count
        puts "Buffer found: [get_name $cell]"
    }
}
puts "Total buffers: $buffer_count"
```

### Working with Hierarchical Designs

```tcl
# Get cells at all hierarchy levels
set all_cells [get_cells -hierarchical *]

# Get cells only at top level
set top_cells [get_cells *]

# Get cells in a specific module
set sub_cells [get_cells sub_module/*]
```

---

## 4. Getting Object Properties

### Cell Properties

```tcl
set cell [get_cells U1]

# Get cell name
set name [get_name $cell]

# Get reference (library cell) name
set ref [get_property $cell ref_name]

# Get cell location (after placement)
set x [get_property $cell x_origin]
set y [get_property $cell y_origin]

# Check if cell is fixed
set is_fixed [get_property $cell is_fixed]
```

### Net Properties

```tcl
set net [get_nets data_out]

# Get net name
set name [get_name $net]

# Get number of connections
set fanout [llength [get_pins -of_objects $net]]

# Get driver pin
set driver [get_pins -of_objects $net -filter "direction == output"]
```

### Pin Properties

```tcl
set pin [get_pins U1/A]

# Get pin name
set name [get_name $pin]

# Get direction
set dir [get_property $pin direction]

# Get connected net
set net [get_nets -of_objects $pin]
```

---

## 5. Design Statistics

### Cell Statistics

```tcl
proc report_cell_stats {} {
    set total 0
    set by_type [dict create]

    foreach cell [get_cells *] {
        incr total
        set ref [get_property $cell ref_name]

        if {[dict exists $by_type $ref]} {
            dict incr by_type $ref
        } else {
            dict set by_type $ref 1
        }
    }

    puts "=== Cell Statistics ==="
    puts "Total cells: $total"
    puts ""
    puts "By type:"
    foreach {type count} $by_type {
        puts [format "  %-20s %5d" $type $count]
    }
}

report_cell_stats
```

### Net Statistics

```tcl
proc report_net_stats {} {
    set total 0
    set max_fanout 0
    set max_fanout_net ""

    foreach net [get_nets *] {
        incr total
        set fanout [llength [get_pins -of_objects $net]]

        if {$fanout > $max_fanout} {
            set max_fanout $fanout
            set max_fanout_net [get_name $net]
        }
    }

    puts "=== Net Statistics ==="
    puts "Total nets: $total"
    puts "Max fanout: $max_fanout (net: $max_fanout_net)"
}

report_net_stats
```

---

## 6. Timing Commands

### Reading SDC Constraints

```tcl
# Read timing constraints
read_sdc constraints.sdc

# Or define inline
create_clock -name clk -period 10 [get_ports clk]
set_input_delay -clock clk 2 [all_inputs]
set_output_delay -clock clk 2 [all_outputs]
```

### Timing Reports

```tcl
# Report worst setup paths
report_checks -path_delay max -sort_by_slack

# Report worst hold paths
report_checks -path_delay min -sort_by_slack

# Report specific number of paths
report_checks -path_delay max -sort_by_slack -endpoint_count 10

# Report paths through a specific pin
report_checks -through [get_pins U1/Y]

# Get timing summary
report_tns  ;# Total Negative Slack
report_wns  ;# Worst Negative Slack
```

### Accessing Timing Data Programmatically

```tcl
# Get worst slack
set worst_slack [sta::worst_slack -max]
puts "Worst setup slack: $worst_slack"

set worst_hold [sta::worst_slack -min]
puts "Worst hold slack: $worst_hold"

# Check if timing is met
if {$worst_slack >= 0} {
    puts "Setup timing MET"
} else {
    puts "Setup timing VIOLATED by [expr {abs($worst_slack)}] ns"
}
```

---

## 7. Physical Design Commands

### Floorplanning

```tcl
# Initialize floorplan
initialize_floorplan -die_area "0 0 1000 800" \
                     -core_area "50 50 950 750" \
                     -site FreePDK45_38x28_10R_NP_162NW_34O

# Or with utilization
initialize_floorplan -utilization 0.6 \
                     -aspect_ratio 1.0 \
                     -core_space 20

# Create tracks
make_tracks
```

### IO Placement

```tcl
# Auto-place IOs
place_pins -hor_layers M3 -ver_layers M2

# Or manual placement
place_pin -pin_name clk -layer M3 -location {500 0} -pin_size {1 2}
```

### Placement

```tcl
# Global placement
global_placement -density 0.7

# Detailed placement
detailed_placement

# Check placement
check_placement
```

### Clock Tree Synthesis

```tcl
# Configure CTS
set_wire_rc -clock -layer M4

# Run CTS
clock_tree_synthesis -root_buf BUF_X4 \
                     -buf_list {BUF_X2 BUF_X4 BUF_X8}

# Repair clock nets
repair_clock_nets
```

### Routing

```tcl
# Global routing
global_route -guide_file route.guide \
             -layers M1-M6

# Detailed routing
detailed_route -guide route.guide \
               -output_drc route_drc.rpt

# Check DRC
check_drc
```

---

## 8. Writing Output Files

```tcl
# Write DEF (physical design)
write_def output.def

# Write Verilog netlist
write_verilog output.v

# Write SDC constraints
write_sdc output.sdc

# Write SPEF (parasitics)
write_spef output.spef

# Write GDS (layout)
write_gds output.gds
```

---

## 9. Common Utility Procedures

### Finding Critical Paths

```tcl
proc find_critical_cells {} {
    set critical_cells [list]

    # Get paths with negative slack
    set paths [sta::find_timing_paths -sort_by_slack -path_count 100]

    foreach path $paths {
        set slack [sta::path_slack $path]
        if {$slack < 0} {
            # Get cells on this path
            foreach pin [sta::path_pins $path] {
                set cell [get_cells -of_objects $pin]
                if {$cell ne "" && [lsearch $critical_cells $cell] < 0} {
                    lappend critical_cells $cell
                }
            }
        }
    }

    return $critical_cells
}
```

### Checking Design Rules

```tcl
proc check_design_health {} {
    puts "=== Design Health Check ==="

    # Check for unconnected pins
    set floating_pins [get_pins -filter "net_name == {}"]
    if {[llength $floating_pins] > 0} {
        puts "WARNING: [llength $floating_pins] floating pins"
    } else {
        puts "OK: No floating pins"
    }

    # Check timing
    set wns [sta::worst_slack -max]
    if {$wns < 0} {
        puts "FAIL: Setup WNS = $wns ns"
    } else {
        puts "PASS: Setup timing met (WNS = $wns ns)"
    }

    set whs [sta::worst_slack -min]
    if {$whs < 0} {
        puts "FAIL: Hold WNS = $whs ns"
    } else {
        puts "PASS: Hold timing met (WNS = $whs ns)"
    }
}
```

---

## Exercises

### Exercise 1: Count Cell Types
```tcl
# TODO: Write a procedure that counts cells by category:
# - Sequential (contains "DFF" or "LATCH" in ref_name)
# - Buffer (starts with "BUF")
# - Inverter (starts with "INV")
# - Combinational (everything else)

proc count_cell_categories {} {
    # Your code here

}

# Test after loading a design
count_cell_categories
```

<details>
<summary>Solution</summary>

```tcl
proc count_cell_categories {} {
    set seq_count 0
    set buf_count 0
    set inv_count 0
    set comb_count 0

    foreach cell [get_cells *] {
        set ref [get_property $cell ref_name]

        if {[string match "*DFF*" $ref] || [string match "*LATCH*" $ref]} {
            incr seq_count
        } elseif {[string match "BUF*" $ref]} {
            incr buf_count
        } elseif {[string match "INV*" $ref]} {
            incr inv_count
        } else {
            incr comb_count
        }
    }

    puts "=== Cell Categories ==="
    puts "Sequential:    $seq_count"
    puts "Buffers:       $buf_count"
    puts "Inverters:     $inv_count"
    puts "Combinational: $comb_count"
    puts "Total:         [expr {$seq_count + $buf_count + $inv_count + $comb_count}]"
}
```
</details>

---

### Exercise 2: Find High-Fanout Nets
```tcl
# TODO: Write a procedure that finds nets with fanout > threshold
# and returns them sorted by fanout (highest first)

proc find_high_fanout_nets {{threshold 10}} {
    # Your code here

}

# Test:
# find_high_fanout_nets 20
```

<details>
<summary>Solution</summary>

```tcl
proc find_high_fanout_nets {{threshold 10}} {
    set high_fanout [list]

    foreach net [get_nets *] {
        set net_name [get_name $net]
        set pins [get_pins -of_objects $net]
        set fanout [llength $pins]

        if {$fanout > $threshold} {
            lappend high_fanout [list $net_name $fanout]
        }
    }

    # Sort by fanout (descending)
    set sorted [lsort -index 1 -integer -decreasing $high_fanout]

    puts "=== High Fanout Nets (> $threshold) ==="
    foreach item $sorted {
        set name [lindex $item 0]
        set fo [lindex $item 1]
        puts [format "  %-40s fanout: %d" $name $fo]
    }

    return $sorted
}
```
</details>

---

### Exercise 3: Report Timing Summary
```tcl
# TODO: Write a procedure that reports timing summary:
# - Setup WNS/TNS
# - Hold WNS/TNS
# - Number of violating endpoints
# - Overall status (PASS/FAIL)

proc report_timing_summary {} {
    # Your code here
    # Hint: Use sta::worst_slack, sta::total_negative_slack

}
```

<details>
<summary>Solution</summary>

```tcl
proc report_timing_summary {} {
    puts ""
    puts "╔════════════════════════════════════════╗"
    puts "║         Timing Summary Report          ║"
    puts "╚════════════════════════════════════════╝"
    puts ""

    # Setup timing
    set setup_wns [sta::worst_slack -max]
    set setup_tns [sta::total_negative_slack -max]

    puts "Setup Timing:"
    puts [format "  WNS: %8.3f ns" $setup_wns]
    puts [format "  TNS: %8.3f ns" $setup_tns]

    if {$setup_wns >= 0} {
        puts "  Status: PASS"
    } else {
        puts "  Status: FAIL"
    }

    puts ""

    # Hold timing
    set hold_wns [sta::worst_slack -min]
    set hold_tns [sta::total_negative_slack -min]

    puts "Hold Timing:"
    puts [format "  WNS: %8.3f ns" $hold_wns]
    puts [format "  TNS: %8.3f ns" $hold_tns]

    if {$hold_wns >= 0} {
        puts "  Status: PASS"
    } else {
        puts "  Status: FAIL"
    }

    puts ""

    # Overall status
    if {$setup_wns >= 0 && $hold_wns >= 0} {
        puts "Overall: ✓ TIMING MET"
    } else {
        puts "Overall: ✗ TIMING VIOLATED"
    }

    puts ""
}
```
</details>

---

### Exercise 4: Export Pin List
```tcl
# TODO: Write a procedure that exports all ports to a CSV file
# Format: port_name,direction,layer,x,y

proc export_ports_csv {filename} {
    # Your code here
    # Hint: Use get_ports, get_property, open/puts/close

}

# Test:
# export_ports_csv "ports.csv"
```

<details>
<summary>Solution</summary>

```tcl
proc export_ports_csv {filename} {
    set fp [open $filename w]

    # Header
    puts $fp "port_name,direction,x,y"

    foreach port [get_ports *] {
        set name [get_name $port]
        set dir [get_property $port direction]

        # Try to get location (may not exist before IO placement)
        if {[catch {
            set x [get_property $port x]
            set y [get_property $port y]
        }]} {
            set x "N/A"
            set y "N/A"
        }

        puts $fp "$name,$dir,$x,$y"
    }

    close $fp
    puts "Exported [llength [get_ports *]] ports to $filename"
}
```
</details>

---

### Exercise 5: Design Checker Script
```tcl
# TODO: Create a comprehensive design checker that verifies:
# 1. All libraries are loaded
# 2. Design is linked
# 3. No floating pins
# 4. Clock is defined
# 5. Timing constraints exist

proc check_design_ready {} {
    set errors 0

    # Your code here

    if {$errors == 0} {
        puts "\n✓ Design is ready for physical design flow"
    } else {
        puts "\n✗ Found $errors issue(s) - please fix before proceeding"
    }

    return $errors
}
```

<details>
<summary>Solution</summary>

```tcl
proc check_design_ready {} {
    set errors 0

    puts "=== Design Readiness Check ==="
    puts ""

    # 1. Check if libraries are loaded
    puts "1. Library Check:"
    if {[catch {get_libs *} libs] || [llength $libs] == 0} {
        puts "   ✗ No libraries loaded"
        incr errors
    } else {
        puts "   ✓ [llength $libs] library(ies) loaded"
    }

    # 2. Check if design is linked
    puts "2. Design Link Check:"
    if {[catch {get_cells *} cells] || [llength $cells] == 0} {
        puts "   ✗ No cells found - design may not be linked"
        incr errors
    } else {
        puts "   ✓ Design linked with [llength $cells] cells"
    }

    # 3. Check for floating pins
    puts "3. Connectivity Check:"
    if {[catch {
        set floating [get_pins -filter "net_name == {}"]
        set float_count [llength $floating]
    }]} {
        set float_count 0
    }

    if {$float_count > 0} {
        puts "   ✗ $float_count floating pin(s) found"
        incr errors
    } else {
        puts "   ✓ No floating pins"
    }

    # 4. Check for clock definition
    puts "4. Clock Check:"
    if {[catch {get_clocks *} clocks] || [llength $clocks] == 0} {
        puts "   ✗ No clocks defined"
        incr errors
    } else {
        puts "   ✓ [llength $clocks] clock(s) defined"
    }

    # 5. Check timing constraints
    puts "5. Constraints Check:"
    if {[catch {sta::worst_slack -max} slack]} {
        puts "   ✗ Cannot read timing - constraints may be missing"
        incr errors
    } else {
        puts "   ✓ Timing constraints loaded (WNS: $slack)"
    }

    puts ""

    if {$errors == 0} {
        puts "✓ Design is ready for physical design flow"
    } else {
        puts "✗ Found $errors issue(s) - please fix before proceeding"
    }

    return $errors
}
```
</details>

---

## Quick Reference Card

| Category | Command | Description |
|----------|---------|-------------|
| **Load** | `read_lef` | Read LEF file |
| | `read_liberty` | Read Liberty file |
| | `read_verilog` | Read Verilog netlist |
| | `link_design` | Link design |
| | `read_sdc` | Read timing constraints |
| **Query** | `get_cells` | Get cell objects |
| | `get_nets` | Get net objects |
| | `get_pins` | Get pin objects |
| | `get_ports` | Get port objects |
| | `get_clocks` | Get clock objects |
| **Properties** | `get_name` | Get object name |
| | `get_property` | Get object property |
| | `-of_objects` | Get connected objects |
| | `-filter` | Filter by condition |
| **Timing** | `report_checks` | Report timing paths |
| | `report_tns` | Total negative slack |
| | `report_wns` | Worst negative slack |
| | `sta::worst_slack` | Get worst slack value |
| **Physical** | `initialize_floorplan` | Create floorplan |
| | `global_placement` | Run global placement |
| | `detailed_placement` | Run detailed placement |
| | `clock_tree_synthesis` | Run CTS |
| | `global_route` | Run global routing |
| | `detailed_route` | Run detailed routing |
| **Output** | `write_def` | Write DEF file |
| | `write_verilog` | Write Verilog |
| | `write_sdc` | Write SDC |

---

## Next Steps

Now that you understand TCL and the OpenROAD API, you're ready to tackle the puzzles!

Start with: `puzzles/01_synthesis/syn_001/`

**Previous**: [02_control_flow.md](02_control_flow.md) - Conditions, loops, and procedures
