# Phase 1: Floorplanning

**Die/Core Definition and IO Placement**

This phase covers the first step of the Physical Design flow: defining the chip area and placing input/output pins.

---

## Learning Objectives

By the end of this phase, you will be able to:

- Understand the difference between Die and Core
- Calculate utilization and aspect ratio
- Define die/core dimensions in OpenROAD
- Place IO pins on the chip boundary
- Create basic floorplan constraints

---

## Prerequisites

- Completed Phase 0 (TCL basics)
- OpenROAD installed
- Understanding of basic timing concepts

---

## Lessons

### Lesson 01: Die and Core Concepts

Location: `lessons/lesson01_die_core/`

| File | Content |
|------|---------|
| README.md | Lesson overview |
| concepts.md | Die vs Core, utilization, aspect ratio |
| commands.md | OpenROAD floorplan commands |
| examples/ | Practical examples |

**Key Concepts:**
- Die area = total chip area
- Core area = area for standard cells (inside die)
- Utilization = (cell area / core area) x 100%
- Aspect ratio = height / width

### Lesson 02: IO Placement

Location: `lessons/lesson02_io_placement/`

| File | Content |
|------|---------|
| README.md | Lesson overview |
| concepts.md | IO pad types, placement strategies |
| commands.md | IO placement commands |
| examples/ | Placement scripts |
| resources/ | Reference materials |

**Key Concepts:**
- IO pin vs IO pad
- Pin placement on boundaries (N/S/E/W)
- Signal grouping and ordering
- Constraint-based placement

---

## Exercises

Location: `exercises/lesson01_exercises/`

Practice creating floorplans with different:
- Die sizes
- Utilization targets
- Aspect ratios
- IO configurations

---

## Directory Structure

```
phase1_floorplanning/
├── README.md                       # This file
├── lessons/
│   ├── lesson01_die_core/          # Die/Core concepts
│   │   ├── README.md
│   │   ├── concepts.md
│   │   ├── commands.md
│   │   └── examples/
│   └── lesson02_io_placement/      # IO placement
│       ├── README.md
│       ├── concepts.md
│       ├── commands.md
│       ├── examples/
│       └── resources/
└── exercises/
    └── lesson01_exercises/         # Hands-on practice
```

---

## Key OpenROAD Commands

```tcl
# Initialize floorplan
initialize_floorplan -die_area {x1 y1 x2 y2} \
                     -core_area {x1 y1 x2 y2} \
                     -site <site_name>

# Or use utilization-based sizing
initialize_floorplan -utilization <percent> \
                     -aspect_ratio <ratio> \
                     -core_space <margin>

# Place IO pins
place_pins -hor_layers <layers> \
           -ver_layers <layers>

# Set IO constraints
set_io_pin_constraint -pin_names {pin1 pin2} \
                      -region <edge>
```

---

## Formulas

### Utilization
```
Utilization (%) = (Total Cell Area / Core Area) × 100
```
Typical values: 60-80%

### Aspect Ratio
```
Aspect Ratio = Core Height / Core Width
```
Typical value: 1.0 (square)

### Core to Die Relationship
```
Die Area = Core Area + (2 × Margin)²
```

---

## Next Steps

After completing Phase 1:

1. **PD Puzzles** - Try `pd-puzzles/puzzles/02_floorplan/flp_001/`
2. **ALU Project** - Study `project_alu8bits/scripts/02_floorplan.tcl`
