# PD-Puzzles

**Physical Design Puzzle Challenges with OpenROAD**

Learn by debugging real-world Physical Design problems. Each puzzle presents a broken or misconfigured design that you must fix.

---

## Concept

Puzzles simulate **real problems** that PD engineers face daily:
- Debugging TCL scripts
- Fixing timing violations
- Analyzing and correcting tool errors
- Optimizing design results

> **Philosophy**: Focus on skills where human expertise matters - debugging, analysis, and decision-making.

---

## Getting Started

### 1. Verify PDK Installation

```bash
cd setup
openroad verify_install.tcl
```

### 2. Learn TCL Basics (Recommended)

```bash
cd tcl_fundamentals
# Follow: 01_basics.md → 02_control_flow.md → 03_openroad_api.md
```

### 3. Start Your First Puzzle

```bash
cd puzzles/01_synthesis/syn_001_library
cat PROBLEM.md              # Read the problem
openroad run.tcl            # Try to run (it will fail)
# Debug and fix the issue
cat QUIZ.md                 # Validate your understanding
```

---

## Puzzle Overview

### 3-Day Learning Path

| Day | Level | PDK | Puzzles |
|-----|-------|-----|---------|
| Day 1 | Beginner | Nangate45 (45nm) | 6 puzzles |
| Day 2 | Intermediate | Sky130HD (130nm) | 6 puzzles |
| Day 3 | Advanced | ASAP7 (7nm) | 6 puzzles |

**Total: 18 puzzles** covering the complete RTL-to-GDS flow.

---

## Available Puzzles

### 01_synthesis/

| Puzzle | Name | Level | PDK |
|--------|------|-------|-----|
| syn_001 | The Missing Library | Beginner | Nangate45 |
| syn_002 | The Corner Chaos | Intermediate | Sky130HD |
| syn_003 | The Voltage Vortex | Advanced | ASAP7 |

### 02_floorplan/

| Puzzle | Name | Level | PDK |
|--------|------|-------|-----|
| flp_001 | The Vanishing Voltage | Beginner | Nangate45 |
| flp_002 | The Halo Headache | Intermediate | Sky130HD |
| flp_003 | Density Disaster | Advanced | ASAP7 |

### 03_placement/

| Puzzle | Name | Level | PDK |
|--------|------|-------|-----|
| plc_001 | The Density Dilemma | Beginner | Nangate45 |
| plc_002 | The Timing Turmoil | Intermediate | Sky130HD |
| plc_003 | Padding Panic | Advanced | ASAP7 |

### 04_cts/

| Puzzle | Name | Level | PDK |
|--------|------|-------|-----|
| cts_001 | The Missing Clock | Beginner | Nangate45 |
| cts_002 | The Buffer Bonanza | Intermediate | Sky130HD |
| cts_003 | Sink Shuffle | Advanced | ASAP7 |

### 05_routing/

| Puzzle | Name | Level | PDK |
|--------|------|-------|-----|
| rte_001 | The Layer Labyrinth | Beginner | Nangate45 |
| rte_002 | The Adjustment Agony | Intermediate | Sky130HD |
| rte_003 | NDR Nightmare | Advanced | ASAP7 |

### 06_signoff/

| Puzzle | Name | Level | PDK |
|--------|------|-------|-----|
| sgn_001 | The Timing Terror | Beginner | Nangate45 |
| sgn_002 | The Constraint Crisis | Intermediate | Sky130HD |
| sgn_003 | Corner Catastrophe | Advanced | ASAP7 |

---

## PDKs Used

| PDK | Node | Day | Key Concepts |
|-----|------|-----|--------------|
| Nangate45 | 45nm | Day 1 | Basics, fundamentals |
| Sky130HD | 130nm | Day 2 | Real-world open PDK, macros |
| ASAP7 | 7nm | Day 3 | Advanced node, multi-Vt, tight constraints |

---

## Puzzle Structure

Each puzzle folder contains:

```
puzzle_name/
├── PROBLEM.md      # Context, symptoms, objective
├── run.tcl         # Script with TODO items to fix
├── resources/      # Design files (Verilog, SDC, etc.)
├── hints.md        # Progressive hints (if stuck)
├── QUIZ.md         # Validation questions
└── .solution/      # Solution (revealed after quiz)
```

### Difficulty Levels

| Level | Time | Description |
|-------|------|-------------|
| Beginner | 15-20 min | Fundamental concepts, simple errors |
| Intermediate | 20-30 min | Common problems, analysis required |
| Advanced | 20-30 min | Complex multi-factor issues, advanced nodes |

---

## Directory Structure

```
pd-puzzles/
├── setup/                  # PDK verification
│   └── verify_install.tcl
│
├── tcl_fundamentals/       # TCL crash course
│   ├── 01_basics.md
│   ├── 02_control_flow.md
│   ├── 03_openroad_api.md
│   └── exercises/
│
├── puzzles/                # All puzzle categories
│   ├── 01_synthesis/
│   ├── 02_floorplan/
│   ├── 03_placement/
│   ├── 04_cts/
│   ├── 05_routing/
│   └── 06_signoff/
│
├── PROGRESS.md             # Track your progress
└── README.md               # This file
```

---

## Progress Tracking

Track your progress in [PROGRESS.md](PROGRESS.md)

**Achievements to unlock:**
- Day 1/2/3 Complete
- Synthesizer, Architect, Placer, Clock Master, Router, Sign-off Pro
- **PD Master** - Complete all 18 puzzles!

---

## Skills Developed

### By Phase

| Phase | Skills |
|-------|--------|
| Synthesis | Library loading, multi-Vt cells, constraint setup |
| Floorplan | Die sizing, PDN configuration, macro placement |
| Placement | Density control, padding, timing-driven placement |
| CTS | Buffer selection, sink clustering, skew optimization |
| Routing | Layer configuration, congestion management, NDR |
| Signoff | Parasitic estimation, I/O constraints, multi-corner analysis |

### By PDK

| PDK | Advanced Topics |
|-----|-----------------|
| Nangate45 | Basic flow, fundamental commands |
| Sky130HD | Real PDK quirks, macro handling |
| ASAP7 | 7nm challenges, multi-Vt, tight metal pitches |

---

## Tips for Success

1. **Read the error messages carefully** - They often point to the exact problem
2. **Use hints progressively** - Don't jump to solutions
3. **Complete the quiz** - It validates deep understanding
4. **Experiment** - Try different values to see their effects
5. **Take notes** - Document what you learn for future reference
6. **Follow the progression** - Day 1 → Day 2 → Day 3

---

## Requirements

- OpenROAD (latest version)
- OpenROAD-flow-scripts (for PDKs)
- Basic TCL knowledge (see tcl_fundamentals/)

---

## License

Educational use. PDKs are subject to their respective licenses.
