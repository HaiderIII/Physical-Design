# Solution: FLP_005 - Utilization Utopia

## The Bug

The die area is drastically undersized for the DSP engine design:

```tcl
initialize_floorplan -die_area "0 0 50 50" \
                     -core_area "5 5 45 45" \
                     -site FreePDK45_38x28_10R_NP_162NW_34O
```

**Problem**: Core area = 40 × 40 = 1,600 um², but design needs ~15,677 um²

## Why This Happens

The DSP engine contains:
- 4 parallel 16×16 bit multipliers (large combinational logic)
- 3 pipeline stages with registers
- 4 accumulators (40-bit each)
- Mode selection logic
- Overflow detection

This creates ~11,000 standard cells requiring ~15,700 um² of area.

## The Fix

Use `-utilization` to let OpenROAD calculate proper dimensions:

```tcl
initialize_floorplan -utilization 0.6 \
                     -aspect_ratio 1.0 \
                     -core_space 10 \
                     -site FreePDK45_38x28_10R_NP_162NW_34O
```

**Or** calculate manually:
```tcl
initialize_floorplan -die_area "0 0 178 178" \
                     -core_area "8 8 170 170" \
                     -site FreePDK45_38x28_10R_NP_162NW_34O
```

## Calculation Method

1. Get design area from synthesis: ~15,677 um²
2. Choose target utilization: 60%
3. Calculate core area: 15677 / 0.60 = 26,128 um²
4. Core side (1:1 ratio): √26128 = 162 um
5. Add 10% margin: 162 × 1.10 = 178 um
6. Core margin: (178 - 162) / 2 = 8 um

## Industry Practice

| Method | When to Use |
|--------|-------------|
| `-utilization` | Early exploration, prototyping |
| `-die_area/-core_area` | Fixed die size from package/foundry |

**Typical utilization targets:**
| Design Type | Target |
|-------------|--------|
| High performance | 50-60% |
| Standard | 60-70% |
| Area-optimized | 70-80% |

## Quiz Answers

1. **B** - The cells require 11x more area than available
2. **B** - Total area of all standard cells after synthesis
3. **B** - 1600 um² (40 × 40)
4. **C** - ~26,100 um² (15677 / 0.60)
5. **B** - Core area is inside die area, leaving margin for I/O
6. **B** - 5 um on each side
7. **B** - Increase die_area and core_area dimensions
