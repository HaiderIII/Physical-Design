# TCL Fundamentals - Part 1: Basics

> 🎯 **Objective**: Master TCL variables, lists, strings, and expressions - the foundation for all OpenROAD scripting.

---

## 1. Variables

In TCL, everything is a string. Variables are created with `set` and accessed with `$`.

### Creating Variables

```tcl
# Basic variable assignment
set design_name "my_chip"
set num_cells 1500
set utilization 0.65

# Variable with spaces (use quotes or braces)
set long_name "top_level_module"
set path {/home/user/designs/chip}
```

### Accessing Variables

```tcl
# Use $ to get the value
puts $design_name          ;# prints: my_chip
puts "Design: $design_name" ;# prints: Design: my_chip

# Use braces to prevent substitution
puts {$design_name}        ;# prints: $design_name (literal)
```

### Variable Substitution in Strings

```tcl
set lib_name "NangateOpenCellLibrary"
set corner "typical"

# Double quotes allow substitution
set lib_file "${lib_name}_${corner}.lib"
puts $lib_file  ;# prints: NangateOpenCellLibrary_typical.lib

# Braces prevent substitution
set pattern {${lib_name}_*.lib}
puts $pattern   ;# prints: ${lib_name}_*.lib
```

### The `info exists` Command

```tcl
# Check if a variable exists before using it
if {[info exists my_var]} {
    puts "my_var = $my_var"
} else {
    puts "my_var is not defined"
}
```

---

## 2. Lists

Lists are fundamental in TCL - they're used everywhere in OpenROAD scripts.

### Creating Lists

```tcl
# Method 1: Using list command (recommended)
set metals [list M1 M2 M3 M4 M5]

# Method 2: Using braces
set corners {slow typical fast}

# Method 3: From a string (splits on whitespace)
set cells "AND2 OR2 INV"
```

### Accessing List Elements

```tcl
set layers [list M1 M2 M3 M4 M5 M6]

# Get element by index (0-based)
lindex $layers 0      ;# returns: M1
lindex $layers 2      ;# returns: M3
lindex $layers end    ;# returns: M6
lindex $layers end-1  ;# returns: M5

# Get list length
llength $layers       ;# returns: 6

# Get a range
lrange $layers 1 3    ;# returns: M2 M3 M4
```

### Modifying Lists

```tcl
set cells [list INV BUF]

# Append to list
lappend cells AND2 OR2
puts $cells  ;# prints: INV BUF AND2 OR2

# Insert at position
set cells [linsert $cells 1 NAND2]
puts $cells  ;# prints: INV NAND2 BUF AND2 OR2

# Replace element
set cells [lreplace $cells 0 0 INV_X1]
puts $cells  ;# prints: INV_X1 NAND2 BUF AND2 OR2
```

### Searching in Lists

```tcl
set std_cells [list AND2_X1 OR2_X1 INV_X1 BUF_X2 AND2_X2]

# Find index of element
lsearch $std_cells "INV_X1"     ;# returns: 2
lsearch $std_cells "NAND2"      ;# returns: -1 (not found)

# Search with pattern matching
lsearch -glob $std_cells "AND*" ;# returns: 0 (first match)
lsearch -all -glob $std_cells "AND*"  ;# returns: 0 4 (all matches)
```

### Iterating Over Lists

```tcl
set corners [list slow typical fast]

# Using foreach
foreach corner $corners {
    puts "Processing corner: $corner"
}

# With index
set idx 0
foreach corner $corners {
    puts "Corner $idx: $corner"
    incr idx
}
```

---

## 3. Strings

String manipulation is essential for path handling and report parsing.

### String Length and Comparison

```tcl
set name "clock_buffer"

# Length
string length $name           ;# returns: 12

# Comparison
string equal $name "clock_buffer"  ;# returns: 1 (true)
string equal $name "Clock_Buffer"  ;# returns: 0 (false, case-sensitive)
string equal -nocase $name "Clock_Buffer"  ;# returns: 1

# Compare (returns -1, 0, or 1)
string compare "abc" "abd"    ;# returns: -1 (abc < abd)
```

### Substring Operations

```tcl
set path "/home/user/designs/chip/synthesis"

# Get substring by index
string index $path 0          ;# returns: /
string range $path 0 4        ;# returns: /home

# First/last occurrence
string first "/" $path        ;# returns: 0
string last "/" $path         ;# returns: 25
```

### Pattern Matching

```tcl
set filename "design_v2_final.v"

# Glob-style matching
string match "*.v" $filename           ;# returns: 1
string match "design_*" $filename      ;# returns: 1
string match "*final*" $filename       ;# returns: 1
string match "*.tcl" $filename         ;# returns: 0
```

### String Transformation

```tcl
set name "  Clock_Buffer_X2  "

# Trim whitespace
string trim $name             ;# returns: "Clock_Buffer_X2"

# Case conversion
string toupper "hello"        ;# returns: HELLO
string tolower "HELLO"        ;# returns: hello

# Replace
string map {_ -} "clock_tree" ;# returns: clock-tree
string map {X1 X2} "INV_X1"   ;# returns: INV_X2
```

### Splitting and Joining

```tcl
# Split string into list
set path "/home/user/designs"
set parts [split $path "/"]
puts $parts  ;# prints: {} home user designs

# Join list into string
set dirs [list home user designs]
set path [join $dirs "/"]
puts $path   ;# prints: home/user/designs
```

---

## 4. Expressions

The `expr` command evaluates mathematical and logical expressions.

### Arithmetic

```tcl
# Basic math
expr {5 + 3}      ;# returns: 8
expr {10 - 4}     ;# returns: 6
expr {6 * 7}      ;# returns: 42
expr {15 / 4}     ;# returns: 3 (integer division)
expr {15.0 / 4}   ;# returns: 3.75 (float division)
expr {15 % 4}     ;# returns: 3 (modulo)

# Power
expr {2 ** 10}    ;# returns: 1024

# With variables (always use braces for safety!)
set width 100
set height 50
set area [expr {$width * $height}]
puts $area        ;# prints: 5000
```

### Comparison Operators

```tcl
expr {5 > 3}      ;# returns: 1 (true)
expr {5 < 3}      ;# returns: 0 (false)
expr {5 == 5}     ;# returns: 1
expr {5 != 3}     ;# returns: 1
expr {5 >= 5}     ;# returns: 1
expr {5 <= 4}     ;# returns: 0
```

### Logical Operators

```tcl
expr {1 && 1}     ;# returns: 1 (AND)
expr {1 && 0}     ;# returns: 0
expr {1 || 0}     ;# returns: 1 (OR)
expr {!1}         ;# returns: 0 (NOT)

# Combining conditions
set slack -0.5
set is_violation [expr {$slack < 0}]
puts $is_violation  ;# prints: 1
```

### Math Functions

```tcl
expr {abs(-5)}        ;# returns: 5
expr {max(3, 7)}      ;# returns: 7
expr {min(3, 7)}      ;# returns: 3
expr {round(3.7)}     ;# returns: 4
expr {ceil(3.2)}      ;# returns: 4.0
expr {floor(3.8)}     ;# returns: 3.0
expr {sqrt(16)}       ;# returns: 4.0
```

### Practical Example: Utilization Calculation

```tcl
set die_width 1000.0
set die_height 800.0
set cell_area 520000.0

set die_area [expr {$die_width * $die_height}]
set utilization [expr {$cell_area / $die_area * 100}]

puts [format "Die area: %.0f um^2" $die_area]
puts [format "Utilization: %.1f%%" $utilization]
```

---

## 5. Formatting Output

The `format` command creates formatted strings (like printf in C).

```tcl
# Basic formatting
format "Value: %d" 42           ;# returns: "Value: 42"
format "Name: %s" "clock"       ;# returns: "Name: clock"
format "Slack: %.3f ns" -0.125  ;# returns: "Slack: -0.125 ns"

# Width and alignment
format "%10s" "test"            ;# returns: "      test" (right-aligned)
format "%-10s" "test"           ;# returns: "test      " (left-aligned)
format "%08d" 42                ;# returns: "00000042" (zero-padded)

# Scientific notation
format "%.2e" 1234567.0         ;# returns: "1.23e+06"
```

---

## Exercises

### Exercise 1: Variable Manipulation
```tcl
# TODO: Create variables for a design with:
# - design_name = "counter"
# - clock_period = 10.0 (ns)
# - target_freq = calculated from clock_period (in MHz)
# Print: "Design 'counter' targets 100.0 MHz"

# Your code here:

```

<details>
<summary>Solution</summary>

```tcl
set design_name "counter"
set clock_period 10.0
set target_freq [expr {1000.0 / $clock_period}]
puts "Design '$design_name' targets $target_freq MHz"
```
</details>

---

### Exercise 2: List Operations
```tcl
# TODO: Given this list of metal layers:
set metals [list M1 M2 M3 M4 M5 M6 M7 M8 M9]

# 1. Get the number of layers
# 2. Get the first routing layer (M2, index 1)
# 3. Get the top two layers
# 4. Check if "M5" exists in the list

# Your code here:

```

<details>
<summary>Solution</summary>

```tcl
set metals [list M1 M2 M3 M4 M5 M6 M7 M8 M9]

# 1. Number of layers
set num_layers [llength $metals]
puts "Number of layers: $num_layers"

# 2. First routing layer
set first_route [lindex $metals 1]
puts "First routing layer: $first_route"

# 3. Top two layers
set top_two [lrange $metals end-1 end]
puts "Top two layers: $top_two"

# 4. Check if M5 exists
set m5_idx [lsearch $metals "M5"]
if {$m5_idx >= 0} {
    puts "M5 found at index $m5_idx"
} else {
    puts "M5 not found"
}
```
</details>

---

### Exercise 3: String Parsing
```tcl
# TODO: Parse this Liberty file path to extract components
set lib_path "/pdk/sky130/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"

# Extract:
# 1. The filename (sky130_fd_sc_hd__tt_025C_1v80.lib)
# 2. The corner from filename (tt)
# 3. The voltage from filename (1v80)
# Hint: Use string last, string range, split

# Your code here:

```

<details>
<summary>Solution</summary>

```tcl
set lib_path "/pdk/sky130/lib/sky130_fd_sc_hd__tt_025C_1v80.lib"

# 1. Extract filename
set last_slash [string last "/" $lib_path]
set filename [string range $lib_path [expr {$last_slash + 1}] end]
puts "Filename: $filename"

# Alternative using split:
# set parts [split $lib_path "/"]
# set filename [lindex $parts end]

# 2. Extract corner (between __ and _)
# Filename: sky130_fd_sc_hd__tt_025C_1v80.lib
set parts [split $filename "_"]
# After double underscore: tt, 025C, 1v80.lib
set corner_idx [lsearch $parts "hd"]
set corner [lindex $parts [expr {$corner_idx + 2}]]
puts "Corner: $corner"

# 3. Extract voltage
set voltage [lindex $parts end]
set voltage [string map {.lib ""} $voltage]
puts "Voltage: $voltage"
```
</details>

---

### Exercise 4: Utilization Math
```tcl
# TODO: Calculate placement utilization
# Given:
set die_llx 0.0      ;# lower-left x
set die_lly 0.0      ;# lower-left y
set die_urx 500.0    ;# upper-right x
set die_ury 400.0    ;# upper-right y
set total_cell_area 150000.0  ;# in um^2

# Calculate:
# 1. Die area
# 2. Utilization percentage
# 3. Print formatted: "Utilization: XX.X%"

# Your code here:

```

<details>
<summary>Solution</summary>

```tcl
set die_llx 0.0
set die_lly 0.0
set die_urx 500.0
set die_ury 400.0
set total_cell_area 150000.0

# 1. Die area
set die_width [expr {$die_urx - $die_llx}]
set die_height [expr {$die_ury - $die_lly}]
set die_area [expr {$die_width * $die_height}]
puts "Die area: $die_area um^2"

# 2. Utilization
set utilization [expr {$total_cell_area / $die_area * 100.0}]

# 3. Formatted output
puts [format "Utilization: %.1f%%" $utilization]
```
</details>

---

### Exercise 5: Build a File Path
```tcl
# TODO: Construct paths for a multi-corner analysis
# Given:
set pdk_root "/home/user/pdk/sky130"
set lib_name "sky130_fd_sc_hd"
set corners [list ff ss tt]
set temperatures [list n40 025 125]

# Build and print paths like:
# /home/user/pdk/sky130/lib/sky130_fd_sc_hd__ff_n40C_1v95.lib
# (corner ff, temp n40, voltage 1v95 for ff)
# Use voltage: ff->1v95, ss->1v60, tt->1v80

# Your code here:

```

<details>
<summary>Solution</summary>

```tcl
set pdk_root "/home/user/pdk/sky130"
set lib_name "sky130_fd_sc_hd"
set corners [list ff ss tt]
set temperatures [list n40 025 125]

# Voltage mapping
array set voltages {
    ff 1v95
    ss 1v60
    tt 1v80
}

foreach corner $corners {
    foreach temp $temperatures {
        set voltage $voltages($corner)
        set filename "${lib_name}__${corner}_${temp}C_${voltage}.lib"
        set full_path [file join $pdk_root "lib" $filename]
        puts $full_path
    }
}
```
</details>

---

## Quick Reference Card

| Operation | Command | Example |
|-----------|---------|---------|
| Set variable | `set` | `set x 10` |
| Get variable | `$` | `puts $x` |
| Create list | `list` | `set l [list a b c]` |
| List length | `llength` | `llength $l` |
| List element | `lindex` | `lindex $l 0` |
| Append to list | `lappend` | `lappend l d` |
| Search list | `lsearch` | `lsearch $l "b"` |
| String length | `string length` | `string length $s` |
| String match | `string match` | `string match "*.v" $f` |
| Split string | `split` | `split $path "/"` |
| Join list | `join` | `join $l "/"` |
| Math | `expr` | `expr {$a + $b}` |
| Format | `format` | `format "%.2f" $x` |

---

**Next**: [02_control_flow.md](02_control_flow.md) - Conditions, loops, and procedures
