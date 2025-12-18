# Phase 0: Foundations

**TCL Scripting and OpenSTA Basics**

This phase covers the fundamental skills needed before diving into Physical Design: TCL programming and static timing analysis with OpenSTA.

---

## Learning Objectives

By the end of this phase, you will be able to:

- Write TCL scripts for EDA tool automation
- Understand control flow, procedures, and file I/O in TCL
- Use regular expressions for text processing
- Run basic timing analysis with OpenSTA
- Read and interpret timing reports

---

## Prerequisites

- OpenSTA installed (`sta -version`)
- Text editor (VSCode, vim, etc.)
- Terminal access

---

## Course Content

Located in `cours/`:

| Lesson | Topic | Description |
|--------|-------|-------------|
| 01 | TCL Basics | Variables, data types, operators |
| 02 | Control Flow | if/else, loops (for, while, foreach) |
| 03 | Procedures | Functions, variable scope, arguments |
| 04 | Strings & Lists | String manipulation, list operations |
| 05 | File Operations | Reading/writing files, file handling |
| 05bis | Regular Expressions | Pattern matching, text processing |
| 06 | OpenSTA Intro | Basic STA commands, timing concepts |

### Recommended Order

```
01_tcl_basics.md
    ↓
02_control_flow.md
    ↓
03_procedures_functions.md
    ↓
04_strings_lists.md
    ↓
05_file_operations.md
    ↓
05bis_regular_expressions.md
    ↓
06_opensta_intro.md
```

---

## Exercises

Located in `exercices/`:

| File | Focus |
|------|-------|
| cours2_patterns.tcl | Control flow practice |
| cours3_patterns.tcl | Procedure writing |
| exercices_cours3.tcl | Functions and scope |
| exercices_cours4.tcl | String/list operations |
| exercices_cours5.tcl | File I/O |
| 05bis_regex_exercises.tcl | Regular expressions |
| lesson06_opensta/ | OpenSTA hands-on |

---

## Solutions

Reference solutions are in `solutions/`

---

## Directory Structure

```
phase_00_foundations/
├── README.md           # This file
├── cours/              # Theory lessons (7 markdown files)
├── exercices/          # Hands-on exercises
├── solutions/          # Reference solutions
└── resources/          # Additional materials
```

---

## Getting Started

### Step 1: Read the first lesson
```bash
cat cours/01_tcl_basics.md
```

### Step 2: Practice interactively
```bash
tclsh
# Try the examples from the lesson
```

### Step 3: Complete exercises
```bash
tclsh exercices/cours2_patterns.tcl
```

### Step 4: Check your solutions
```bash
cat solutions/<exercise_name>
```

---

## Key Concepts Covered

### TCL Fundamentals
- Variables: `set`, `puts`, `expr`
- Lists: `list`, `lindex`, `llength`, `foreach`
- Strings: `string length`, `string range`, `regexp`
- Control: `if`, `for`, `while`, `switch`
- Procedures: `proc`, `return`, `global`, `upvar`
- Files: `open`, `gets`, `puts`, `close`

### OpenSTA Basics
- Reading libraries: `read_liberty`
- Reading designs: `read_verilog`, `link_design`
- Timing constraints: `read_sdc`
- Reports: `report_checks`, `report_clock_properties`

---

## Next Steps

After completing Phase 0:

1. **Phase 1: Floorplanning** - `../phase1_floorplanning/`
2. **PD Puzzles** - `../../pd-puzzles/` (apply your TCL skills)
