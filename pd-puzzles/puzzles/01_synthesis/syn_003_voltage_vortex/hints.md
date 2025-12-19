# Hints - syn_003: Voltage Vortex

## Hint 1: Cell Naming Convention
Look at the cell names in the netlist (`resources/alu_netlist.v`):
```verilog
AND2x2_ASAP7_75t_R
DFFHQNx1_ASAP7_75t_R
```

The suffix `_R` indicates the Vt type. What does `R` stand for?

---

## Hint 2: ASAP7 Vt Types
ASAP7 uses these suffixes:
- `_R` = **R**VT (Regular Vt)
- `_L` = **L**VT (Low Vt)
- `_SL` = **S**uper **L**ow Vt (SLVT)

The library files follow the same convention:
- `asap7sc7p5t_*_RVT_*.lib` contains `_R` cells
- `asap7sc7p5t_*_SLVT_*.lib` contains `_SL` cells

---

## Hint 3: Find the Bug
Look at line ~47 in `run.tcl`:
```tcl
set vt_type "SL"  ;# <-- What should this be?
```

This variable controls which libraries are loaded.

---

## Hint 4: The Fix
The netlist uses RVT cells (`_R` suffix), so you need to load RVT libraries.

Change:
```tcl
set vt_type "SL"
```

To:
```tcl
set vt_type "R"
```

---

## Why This Matters

In production flows:
1. Netlist and libraries MUST match
2. Wrong Vt = cells become black boxes = design fails
3. Multi-Vt is used strategically:
   - Use slow Vt (RVT/HVT) for most cells → low leakage
   - Use fast Vt (LVT/SLVT) only on critical paths → meet timing
