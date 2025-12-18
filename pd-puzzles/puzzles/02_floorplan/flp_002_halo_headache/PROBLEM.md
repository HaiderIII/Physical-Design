# FLP_002 - The Halo Headache

**Phase**: Floorplan
**Level**: Intermediate
**PDK**: Sky130
**Estimated time**: 30-45 min

---

## Context

You're working on a mixed-signal chip at AnalogFirst Corp. The design contains two pre-hardened analog blocks (represented as black-box macros) that must be placed in specific locations.

The analog team is very strict: "Those macros need 10um halos around them - no digital cells within that zone, or we'll have coupling noise issues!"

Your colleague set up the floorplan script, placed the macros, but forgot to add the halos. Now placement is cramming standard cells right up against the macro boundaries, and the analog team is furious.

---

## Observed Symptoms

When you run `openroad run.tcl`, placement succeeds but:

```
[WARNING] Standard cells placed within 2um of macro ANALOG_BLOCK_0
[WARNING] Standard cells placed within 1um of macro ANALOG_BLOCK_1
[INFO] Analog team review: FAILED - cells too close to sensitive macros
```

The verification script detects cells placed inside what should be the halo region.

---

## Objective

Fix the `run.tcl` script to add proper placement halos around the analog macros.

**Success criteria**:
- [ ] Script runs without errors
- [ ] Both macros have 10um halos on all sides
- [ ] No standard cells are placed within the halo regions
- [ ] Verification check passes

---

## Skills Covered

- [ ] Understanding macro placement in floorplanning
- [ ] Creating placement halos/blockages around macros
- [ ] Using `set_placement_padding` or placement blockages
- [ ] Verifying placement constraints

---

## Files Provided

```
flp_002_halo_headache/
├── PROBLEM.md           # This file
├── run.tcl              # Script to fix (missing halo commands)
├── resources/
│   ├── mixed_signal.v   # Design with 2 macro instances
│   ├── analog_macro.v   # Macro definition (black box)
│   └── constraints.sdc  # Timing constraints
├── hints.md             # Progressive hints
└── QUIZ.md              # Validation quiz
```

---

## Key Concepts

### What is a Halo?

A halo (also called keepout or placement blockage) is a region around a macro where standard cells cannot be placed.

```
+------------------------------------------+
|                                          |
|     +-----------------------------+      |
|     |         HALO (10um)         |      |
|     |   +-------------------+     |      |
|     |   |                   |     |      |
|     |   |   ANALOG MACRO    |     |      |
|     |   |                   |     |      |
|     |   +-------------------+     |      |
|     |                             |      |
|     +-----------------------------+      |
|                                          |
|   [Standard cells can be here]           |
+------------------------------------------+
```

### Why Halos Matter

1. **Noise isolation**: Analog blocks are sensitive to digital switching noise
2. **Routing channels**: Space for power straps and signal routing to macro pins
3. **IR drop**: Prevents cells from starving macro power supply
4. **Manufacturability**: Some macros have DRC-sensitive edges

### OpenROAD Halo Commands

```tcl
# Method 1: Placement padding on specific instance
set_placement_padding -masters <macro_name> -left 10 -right 10 -top 10 -bottom 10

# Method 2: Create placement blockage region
create_placement_blockage -bbox {x1 y1 x2 y2}
```

---

## Getting Started

1. Read `run.tcl` and find where macros are placed
2. Notice there's no halo defined around the macros
3. Add the appropriate halo commands after macro placement
4. Test with:

```bash
cd puzzles/02_floorplan/flp_002_halo_headache
openroad run.tcl
```

---

## Rules

1. **Don't look** at the `.solution/` folder before completing the quiz
2. If stuck for more than 10 minutes, check `hints.md`
3. Once the script works, answer the quiz in `QUIZ.md`

---

Good luck!
