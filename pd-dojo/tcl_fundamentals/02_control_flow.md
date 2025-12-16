# TCL Fundamentals - Part 2: Control Flow

> 🎯 **Objective**: Master conditionals, loops, and procedures to write powerful OpenROAD automation scripts.

---

## 1. Conditionals

### Basic `if` Statement

```tcl
set slack -0.15

if {$slack < 0} {
    puts "VIOLATION: Negative slack detected!"
}
```

### `if-else` Statement

```tcl
set utilization 0.75

if {$utilization > 0.8} {
    puts "WARNING: High utilization may cause congestion"
} else {
    puts "Utilization is acceptable"
}
```

### `if-elseif-else` Chain

```tcl
set slack -0.25

if {$slack >= 0} {
    puts "PASS: Timing met"
} elseif {$slack > -0.1} {
    puts "WARNING: Small violation, may be fixable"
} elseif {$slack > -0.5} {
    puts "ERROR: Significant violation"
} else {
    puts "CRITICAL: Severe timing failure"
}
```

### Important Syntax Rules

```tcl
# CORRECT: Opening brace on same line
if {$x > 0} {
    puts "positive"
}

# WRONG: This will cause an error!
if {$x > 0}
{
    puts "positive"
}

# CORRECT: else/elseif on same line as closing brace
if {$x > 0} {
    puts "positive"
} else {
    puts "non-positive"
}

# WRONG: This will cause an error!
if {$x > 0} {
    puts "positive"
}
else {
    puts "non-positive"
}
```

### Compound Conditions

```tcl
set slack -0.1
set is_clock_path 1

# AND condition
if {$slack < 0 && $is_clock_path} {
    puts "Clock path timing violation!"
}

# OR condition
if {$slack < -1.0 || $utilization > 0.95} {
    puts "Design needs major rework"
}

# NOT condition
set has_errors 0
if {!$has_errors} {
    puts "No errors found"
}

# Complex condition with parentheses
if {($slack < 0 && $is_clock_path) || $slack < -0.5} {
    puts "Requires attention"
}
```

### String Conditions

```tcl
set cell_type "BUF_X2"

# String equality
if {$cell_type eq "BUF_X2"} {
    puts "Found buffer"
}

# String inequality
if {$cell_type ne "INV_X1"} {
    puts "Not an inverter"
}

# Pattern matching in condition
if {[string match "BUF_*" $cell_type]} {
    puts "This is a buffer cell"
}

# Check if string is empty
set error_msg ""
if {$error_msg eq ""} {
    puts "No errors"
}
```

### The `switch` Statement

```tcl
set corner "ss"

switch $corner {
    "ff" {
        puts "Fast-fast corner"
        set voltage 1.1
    }
    "tt" {
        puts "Typical corner"
        set voltage 1.0
    }
    "ss" {
        puts "Slow-slow corner"
        set voltage 0.9
    }
    default {
        puts "Unknown corner: $corner"
        set voltage 1.0
    }
}
```

---

## 2. Loops

### `foreach` Loop

The most common loop in TCL scripts.

```tcl
# Basic foreach
set layers [list M1 M2 M3 M4]
foreach layer $layers {
    puts "Processing layer: $layer"
}

# Multiple variables
set coords [list 0 0 100 100 200 200]
foreach {x y} $coords {
    puts "Point: ($x, $y)"
}

# Multiple lists
set names [list clk rst data]
set types [list clock reset signal]
foreach name $names type $types {
    puts "$name is a $type"
}
```

### `for` Loop

C-style loop for counting iterations.

```tcl
# Basic for loop
for {set i 0} {$i < 5} {incr i} {
    puts "Iteration $i"
}

# Counting down
for {set i 10} {$i > 0} {incr i -1} {
    puts "Countdown: $i"
}

# Step by 2
for {set i 0} {$i <= 10} {incr i 2} {
    puts "Even: $i"
}
```

### `while` Loop

```tcl
# Basic while
set count 0
while {$count < 5} {
    puts "Count: $count"
    incr count
}

# Reading until condition met
set iterations 0
set converged 0
while {!$converged && $iterations < 100} {
    # Simulate some optimization
    incr iterations
    if {$iterations > 10} {
        set converged 1
    }
}
puts "Converged after $iterations iterations"
```

### Loop Control: `break` and `continue`

```tcl
# break - exit loop immediately
set cells [list AND2 OR2 ERROR INV BUF]
foreach cell $cells {
    if {$cell eq "ERROR"} {
        puts "Error found, stopping!"
        break
    }
    puts "Processing: $cell"
}
# Output: AND2, OR2, then stops

# continue - skip to next iteration
set values [list 1 -2 3 -4 5]
foreach val $values {
    if {$val < 0} {
        continue  ;# skip negative values
    }
    puts "Positive value: $val"
}
# Output: 1, 3, 5
```

### Nested Loops

```tcl
set rows [list A B C]
set cols [list 1 2 3]

foreach row $rows {
    foreach col $cols {
        puts "Cell: ${row}${col}"
    }
}
# Output: A1, A2, A3, B1, B2, B3, C1, C2, C3
```

### Practical Example: Processing Design Data

```tcl
# Simulated timing report data
set paths [list \
    [list "clk->q" -0.15 "setup"] \
    [list "d->q" 0.25 "setup"] \
    [list "clk->q" -0.02 "hold"] \
    [list "rst->q" 0.50 "setup"] \
]

set violations 0
set worst_slack 999

foreach path $paths {
    set name [lindex $path 0]
    set slack [lindex $path 1]
    set check [lindex $path 2]

    if {$slack < 0} {
        incr violations
        puts "VIOLATION: $name ($check) slack = $slack"
    }

    if {$slack < $worst_slack} {
        set worst_slack $slack
    }
}

puts "Total violations: $violations"
puts "Worst slack: $worst_slack"
```

---

## 3. Procedures

Procedures are reusable blocks of code - essential for clean scripts.

### Basic Procedure

```tcl
proc say_hello {} {
    puts "Hello, PD Engineer!"
}

# Call it
say_hello
```

### Procedures with Arguments

```tcl
proc greet {name} {
    puts "Hello, $name!"
}

greet "Alice"  ;# prints: Hello, Alice!

# Multiple arguments
proc calculate_area {width height} {
    set area [expr {$width * $height}]
    puts "Area: $area"
}

calculate_area 100 50  ;# prints: Area: 5000
```

### Return Values

```tcl
proc calculate_area {width height} {
    return [expr {$width * $height}]
}

set die_area [calculate_area 1000 800]
puts "Die area: $die_area um^2"
```

### Default Arguments

```tcl
proc calculate_utilization {cell_area die_area {target 0.7}} {
    set util [expr {$cell_area / $die_area}]
    if {$util > $target} {
        return "HIGH"
    } else {
        return "OK"
    }
}

# Use default target
puts [calculate_utilization 70000 100000]     ;# OK

# Override target
puts [calculate_utilization 70000 100000 0.6] ;# HIGH
```

### Variable Number of Arguments

```tcl
proc sum_all {args} {
    set total 0
    foreach num $args {
        set total [expr {$total + $num}]
    }
    return $total
}

puts [sum_all 1 2 3]        ;# 6
puts [sum_all 10 20 30 40]  ;# 100
```

### Local vs Global Variables

```tcl
set global_var "I am global"

proc test_scope {} {
    set local_var "I am local"
    puts $local_var

    # Access global variable
    global global_var
    puts $global_var
}

test_scope

# This works
puts $global_var

# This would error - local_var doesn't exist here
# puts $local_var
```

### Using `upvar` for Pass-by-Reference

```tcl
proc double_value {varname} {
    upvar $varname var
    set var [expr {$var * 2}]
}

set x 5
double_value x
puts $x  ;# prints: 10

# Useful for modifying lists
proc append_item {listname item} {
    upvar $listname lst
    lappend lst $item
}

set mylist [list a b c]
append_item mylist "d"
puts $mylist  ;# prints: a b c d
```

### Practical Procedure Examples

```tcl
# Check timing slack
proc check_slack {slack {threshold 0}} {
    if {$slack < $threshold} {
        return "FAIL"
    } else {
        return "PASS"
    }
}

# Format timing report line
proc format_timing {path slack check} {
    set status [check_slack $slack]
    return [format "%-20s %8.3f ns  %-5s  %s" $path $slack $check $status]
}

# Print formatted timing
puts [format_timing "clk->reg1/D" -0.152 "setup"]
puts [format_timing "clk->reg2/D"  0.234 "setup"]
```

---

## 4. Error Handling

### The `catch` Command

```tcl
# Basic error catching
if {[catch {expr {1/0}} result]} {
    puts "Error occurred: $result"
} else {
    puts "Result: $result"
}

# Catch file operations
set filename "nonexistent.tcl"
if {[catch {source $filename} err]} {
    puts "Could not load $filename: $err"
}
```

### The `error` Command

```tcl
proc validate_utilization {util} {
    if {$util < 0 || $util > 1} {
        error "Utilization must be between 0 and 1, got: $util"
    }
    return "Valid"
}

# This will trigger an error
if {[catch {validate_utilization 1.5} msg]} {
    puts "Validation failed: $msg"
}
```

### Try-Finally Pattern

```tcl
proc process_file {filename} {
    set fp [open $filename r]

    if {[catch {
        # Process file contents
        while {[gets $fp line] >= 0} {
            puts $line
        }
    } err]} {
        puts "Error processing file: $err"
    }

    # Always close the file
    close $fp
}
```

---

## Exercises

### Exercise 1: Timing Check Procedure
```tcl
# TODO: Write a procedure that categorizes timing slack:
#   slack >= 0      -> "MET"
#   -0.1 < slack < 0 -> "MARGINAL"
#   -0.5 < slack <= -0.1 -> "VIOLATED"
#   slack <= -0.5   -> "CRITICAL"

proc categorize_slack {slack} {
    # Your code here

}

# Test cases:
puts [categorize_slack 0.5]    ;# should print: MET
puts [categorize_slack -0.05]  ;# should print: MARGINAL
puts [categorize_slack -0.3]   ;# should print: VIOLATED
puts [categorize_slack -1.0]   ;# should print: CRITICAL
```

<details>
<summary>Solution</summary>

```tcl
proc categorize_slack {slack} {
    if {$slack >= 0} {
        return "MET"
    } elseif {$slack > -0.1} {
        return "MARGINAL"
    } elseif {$slack > -0.5} {
        return "VIOLATED"
    } else {
        return "CRITICAL"
    }
}

puts [categorize_slack 0.5]    ;# MET
puts [categorize_slack -0.05]  ;# MARGINAL
puts [categorize_slack -0.3]   ;# VIOLATED
puts [categorize_slack -1.0]   ;# CRITICAL
```
</details>

---

### Exercise 2: Process Cell List
```tcl
# TODO: Write code that:
# 1. Iterates through the cells list
# 2. Counts buffers (cells starting with "BUF")
# 3. Counts inverters (cells starting with "INV")
# 4. Prints the totals

set cells [list BUF_X1 AND2_X1 INV_X1 BUF_X2 OR2_X1 INV_X2 BUF_X4 NAND2_X1]

# Your code here:

```

<details>
<summary>Solution</summary>

```tcl
set cells [list BUF_X1 AND2_X1 INV_X1 BUF_X2 OR2_X1 INV_X2 BUF_X4 NAND2_X1]

set buf_count 0
set inv_count 0

foreach cell $cells {
    if {[string match "BUF_*" $cell]} {
        incr buf_count
    } elseif {[string match "INV_*" $cell]} {
        incr inv_count
    }
}

puts "Buffers: $buf_count"
puts "Inverters: $inv_count"
```
</details>

---

### Exercise 3: Find Worst Path
```tcl
# TODO: Write a procedure that finds the path with worst slack
# Input: list of paths, each path is {name slack}
# Output: returns the path name with worst (most negative) slack

proc find_worst_path {paths} {
    # Your code here

}

# Test:
set timing_paths [list \
    [list "path_A" 0.15] \
    [list "path_B" -0.25] \
    [list "path_C" -0.10] \
    [list "path_D" 0.50] \
]

puts "Worst path: [find_worst_path $timing_paths]"
# Should print: Worst path: path_B
```

<details>
<summary>Solution</summary>

```tcl
proc find_worst_path {paths} {
    set worst_name ""
    set worst_slack 999999

    foreach path $paths {
        set name [lindex $path 0]
        set slack [lindex $path 1]

        if {$slack < $worst_slack} {
            set worst_slack $slack
            set worst_name $name
        }
    }

    return $worst_name
}

set timing_paths [list \
    [list "path_A" 0.15] \
    [list "path_B" -0.25] \
    [list "path_C" -0.10] \
    [list "path_D" 0.50] \
]

puts "Worst path: [find_worst_path $timing_paths]"
```
</details>

---

### Exercise 4: Generate Clock Constraints
```tcl
# TODO: Write a procedure that generates clock constraints
# for multiple corners. Should output TCL commands.
# Input: clock_name, base_period, corners list
# The period should be adjusted:
#   - ff (fast): period * 0.9
#   - tt (typical): period * 1.0
#   - ss (slow): period * 1.1

proc generate_clock_constraints {clock_name base_period corners} {
    # Your code here - should puts each create_clock command

}

# Test:
generate_clock_constraints "clk" 10.0 [list ff tt ss]
# Should output:
# create_clock -name clk -period 9.0 [get_ports clk]  ;# ff corner
# create_clock -name clk -period 10.0 [get_ports clk]  ;# tt corner
# create_clock -name clk -period 11.0 [get_ports clk]  ;# ss corner
```

<details>
<summary>Solution</summary>

```tcl
proc generate_clock_constraints {clock_name base_period corners} {
    foreach corner $corners {
        switch $corner {
            "ff" { set factor 0.9 }
            "tt" { set factor 1.0 }
            "ss" { set factor 1.1 }
            default { set factor 1.0 }
        }

        set period [expr {$base_period * $factor}]
        puts "create_clock -name $clock_name -period $period \[get_ports $clock_name\]  ;# $corner corner"
    }
}

generate_clock_constraints "clk" 10.0 [list ff tt ss]
```
</details>

---

### Exercise 5: Safe Division Procedure
```tcl
# TODO: Write a procedure that safely divides two numbers
# - Returns the result if successful
# - Returns "ERROR" if division by zero
# - Returns "ERROR" if non-numeric input
# Use catch for error handling

proc safe_divide {a b} {
    # Your code here

}

# Test:
puts [safe_divide 10 2]     ;# should print: 5.0
puts [safe_divide 10 0]     ;# should print: ERROR
puts [safe_divide "abc" 2]  ;# should print: ERROR
```

<details>
<summary>Solution</summary>

```tcl
proc safe_divide {a b} {
    if {[catch {
        set result [expr {double($a) / double($b)}]
    } err]} {
        return "ERROR"
    }

    # Check for infinity (division by zero with floats)
    if {$result eq "Inf" || $result eq "-Inf"} {
        return "ERROR"
    }

    return $result
}

puts [safe_divide 10 2]     ;# 5.0
puts [safe_divide 10 0]     ;# ERROR
puts [safe_divide "abc" 2]  ;# ERROR
```
</details>

---

## Quick Reference Card

| Control | Syntax | Example |
|---------|--------|---------|
| if | `if {cond} {body}` | `if {$x > 0} {puts "pos"}` |
| if-else | `if {cond} {body} else {body}` | `if {$x} {puts "yes"} else {puts "no"}` |
| elseif | `if {} {} elseif {} {}` | `if {$x>0} {} elseif {$x<0} {}` |
| switch | `switch $var {val {body}}` | `switch $mode {"fast" {set x 1}}` |
| foreach | `foreach var $list {body}` | `foreach c $cells {puts $c}` |
| for | `for {init} {cond} {incr} {body}` | `for {set i 0} {$i<10} {incr i} {}` |
| while | `while {cond} {body}` | `while {$x < 10} {incr x}` |
| break | `break` | Exit loop immediately |
| continue | `continue` | Skip to next iteration |
| proc | `proc name {args} {body}` | `proc add {a b} {return [expr {$a+$b}]}` |
| return | `return value` | `return $result` |
| catch | `catch {cmd} var` | `if {[catch {expr 1/0} e]} {}` |
| error | `error message` | `error "Invalid input"` |

---

**Previous**: [01_basics.md](01_basics.md) - Variables, lists, strings, expressions

**Next**: [03_openroad_api.md](03_openroad_api.md) - OpenROAD TCL API
