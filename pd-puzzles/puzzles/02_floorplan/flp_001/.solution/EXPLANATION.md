# Explanation - FLP_001: The Impossible Floorplan

## The Bug

The original script specified a die area that was far too small for the design:

```tcl
set die_area {0 0 10 10}   # 10x10 um die
set core_area {2 2 8 8}    # 6x6 um core = 36 um^2
```

But the design has:
- **35 cells**
- **Total cell area: 122 um^2**
- **Current core area: 36 um^2**

That means we're trying to fit 122 um^2 of cells into 36 um^2 of space - a physical impossibility!

The error message `Utilization 494.022 %` comes from: 122 / 24.7 ≈ 494%

---

## The Fix

### Method 1: Automatic Sizing (Recommended)

Let the tool calculate the die size:

```tcl
initialize_floorplan -utilization 0.65 \
                     -aspect_ratio 1.0 \
                     -core_space 2 \
                     -site FreePDK45_38x28_10R_NP_162NW_34O
```

The tool will:
1. Read total cell area (122 um^2)
2. Calculate core area = 122 / 0.65 = 188 um^2
3. Calculate core dimensions = sqrt(188) ≈ 13.7 um
4. Add core_space margins to get die dimensions

### Method 2: Manual Sizing

Calculate yourself and specify explicitly:

```tcl
set die_area {0 0 20 20}
set core_area {2 2 18 18}
initialize_floorplan -die_area $die_area \
                     -core_area $core_area \
                     -site FreePDK45_38x28_10R_NP_162NW_34O
```

This gives:
- Core area = 16 x 16 = 256 um^2
- Utilization = 122 / 256 = 48%

---

## Why This Matters

### In Real Projects

This exact scenario happens frequently:
1. Designer creates floorplan for initial design
2. Design grows (more features, bug fixes)
3. Floorplan isn't updated
4. Placement fails

### Industry Practice

- **Always verify cell area** before finalizing floorplan
- **Use utilization-based** sizing when possible
- **Add 20-30% margin** for late-stage changes
- **Script the calculation** to avoid manual errors

---

## Typical Utilization Guidelines

| Design Type | Utilization | Reason |
|-------------|-------------|--------|
| Memory-heavy | 70-80% | Regular structures, easy routing |
| Standard logic | 60-70% | Typical datapath designs |
| High-performance | 40-50% | Needs room for buffers |
| Very complex | 30-40% | Extreme routing needs |

---

## OpenROAD Commands Used

### `initialize_floorplan`

Creates the basic floorplan structure:
- `-utilization`: Target density (0.0 to 1.0)
- `-aspect_ratio`: Width/Height ratio
- `-core_space`: Margin between core and die
- `-die_area`: Explicit die coordinates {x1 y1 x2 y2}
- `-core_area`: Explicit core coordinates {x1 y1 x2 y2}
- `-site`: Row site name from LEF

### `make_tracks`

Creates routing tracks based on LEF technology definition.

### `place_pins`

Places IO pins on the die boundary:
- `-hor_layers`: Layers for horizontal pins
- `-ver_layers`: Layers for vertical pins

---

## Further Reading

- OpenROAD documentation: Floorplan module
- "Physical Design Essentials" - Chapter on Floor Planning
- IEEE papers on utilization optimization
