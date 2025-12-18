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
cd puzzles/01_synthesis/syn_001
cat PROBLEM.md              # Read the problem
openroad run.tcl            # Try to run (it will fail)
# Debug and fix the issue
cat QUIZ.md                 # Validate your understanding
```

---

## Available Puzzles

### 01_synthesis/

| Puzzle | Name | Difficulty | Focus |
|--------|------|------------|-------|
| syn_001 | The Missing Library | Beginner | Library path configuration |

### 02_floorplan/

| Puzzle | Name | Difficulty | Focus |
|--------|------|------------|-------|
| flp_001 | The Impossible Floorplan | Beginner | Die area calculation |

### 03_placement/

| Puzzle | Name | Difficulty | Focus |
|--------|------|------------|-------|
| plc_001_density | The Density Dilemma | Intermediate | Placement density |

### 04_cts/

| Puzzle | Name | Difficulty | Focus |
|--------|------|------------|-------|
| cts_001_skew | The Buffer Blunder | Intermediate | Clock skew optimization |

### 05_routing/

| Puzzle | Name | Difficulty | Focus |
|--------|------|------------|-------|
| rte_001_layers | The Layer Labyrinth | Intermediate | Routing layer config |

### 06_signoff/

| Puzzle | Name | Difficulty | Focus |
|--------|------|------------|-------|
| sgn_001_timing | The Timing Terror | Advanced | Static timing analysis |

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
| Intermediate | 30-45 min | Common problems, analysis required |
| Advanced | 45-60 min | Complex multi-factor issues |

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
└── common/                 # Shared resources
    └── pdks/nangate45/     # 45nm PDK
```

---

## PDK: Nangate45

All puzzles use the **Nangate45** open-source PDK (45nm):

| Component | File |
|-----------|------|
| Liberty | NangateOpenCellLibrary_typical.lib |
| Tech LEF | NangateOpenCellLibrary.tech.lef |
| Cell LEF | NangateOpenCellLibrary.lef |

Location: `common/pdks/nangate45/`

---

## Progress Tracking

Track your progress in [PROGRESS.md](PROGRESS.md)

---

## Skills Developed

- TCL scripting for EDA tools
- Log analysis and interpretation
- Methodical debugging
- Understanding PD trade-offs
- OpenROAD API usage
- Fixing violations (timing, DRC, antenna)

---

## Tips for Success

1. **Read the error messages carefully** - They often point to the exact problem
2. **Use hints progressively** - Don't jump to solutions
3. **Complete the quiz** - It validates deep understanding
4. **Experiment** - Try different values to see their effects
5. **Take notes** - Document what you learn for future reference
