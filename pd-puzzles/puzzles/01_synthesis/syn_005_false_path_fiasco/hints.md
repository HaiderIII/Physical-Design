# Hints - False Path Fiasco

## Hint 1: What is a False Path?
A false path is a timing path that the tool should NOT analyze. Common examples:
- Asynchronous reset paths (rst_n → registers)
- Test mode paths during normal operation
- Paths between asynchronous clock domains

The command `set_false_path` tells STA to skip these paths.

## Hint 2: Look at the SDC File
Open `resources/constraints.sdc` and examine the false path declarations at the end. What wildcards are being used?

## Hint 3: Wildcard Matching
The wildcards used are:
- `*rst*` - matches any port containing "rst"
- `*first*` - matches any port containing "first"

But look at the port names in the design! Many FUNCTIONAL signals match these patterns.

## Hint 4: What's Being Excluded
The `*rst*` wildcard matches:
- `rst_n` - ✓ Correct, this is the async reset
- `burst_mode` - ✗ Wrong! Contains "rst" in "buRST"
- `burst_length` - ✗ Wrong!
- `burst_active` - ✗ Wrong!
- `burst_done` - ✗ Wrong!
- `start_burst` - ✗ Wrong!
- `first_*` - All the first beat signals!

## Hint 5: The Fix
Replace the wildcards with exact port names:

```tcl
# WRONG - too broad:
# set_false_path -from [get_ports *rst*]

# CORRECT - exact match:
set_false_path -from [get_ports rst_n]
```

Remove the `*first*` false paths entirely - those are functional signals!

## Hint 6: Lesson Learned
Never use wildcards in `set_false_path` unless you're 100% sure of what they match. Always verify with:
```tcl
get_ports *your_pattern*
```

A hidden timing violation is worse than a visible one!
