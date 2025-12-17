# Explanation - PLC_001: The Density Dilemma

## The Bug

The original script used an aggressive placement density:

```tcl
set placement_density 0.95  ;# Too high!
global_placement -density $placement_density
```

A density of 0.95 means "pack cells to fill 95% of available space", leaving only 5% whitespace.

---

## Why This is a Problem

### 1. Legalization Stress

During global placement, cells can overlap (it's a relaxed problem).
During detailed placement (legalization), cells must snap to legal sites.

With high density:
- Many cells compete for the same sites
- Cells must move far from optimal positions
- Results in high delta HPWL

### 2. Routing Impact

Even though routing happens later, placement density affects it:
- Less whitespace = fewer routing channels
- Cells packed together = more wire crossings
- Can lead to congestion and DRC violations

### 3. CTS Impact

Clock Tree Synthesis adds buffers throughout the design:
- With 95% density, where do buffers go?
- May force sub-optimal buffer placement
- Can hurt clock skew and timing

---

## The Fix

```tcl
set placement_density 0.60  ;# Balanced choice
global_placement -density $placement_density
```

A density of 0.60 provides:
- 40% whitespace for routing
- Cells can stay near optimal positions
- Room for CTS buffers
- Better overall timing

---

## Comparing Results

### With density 0.95:
```
Placement Analysis
---------------------------------
total displacement        180+ u
average displacement      1.4+ u
max displacement          4.0+ u
original HPWL            ~850 u
legalized HPWL          ~1100 u
delta HPWL               ~28 %
```

### With density 0.60:
```
Placement Analysis
---------------------------------
total displacement        ~150 u
average displacement      ~1.1 u
max displacement          ~3.5 u
original HPWL            ~875 u
legalized HPWL          ~1000 u
delta HPWL               ~14 %
```

---

## Industry Best Practices

### Density Guidelines by Design Type

| Design Type | Recommended Density | Rationale |
|-------------|---------------------|-----------|
| Memory-dominated | 0.80-0.85 | Regular structure, easy routing |
| Standard logic | 0.60-0.70 | Good balance |
| High-speed | 0.45-0.55 | Need routing space for timing |
| Mixed-signal | 0.40-0.50 | Sensitive to noise, needs spacing |

### When to Use Higher Density

- Simple designs with few nets
- Area-critical (cost-sensitive) applications
- When you've verified routing can handle it

### When to Use Lower Density

- Complex routing (many nets, congested areas)
- Timing-critical paths
- Designs that will have many ECO changes
- First tapeout (play it safe)

---

## OpenROAD Placement Commands

### `global_placement`

Key parameters:
- `-density`: Target packing (0.0 to 1.0)
- `-timing_driven`: Consider timing during placement
- `-routability_driven`: Consider routing during placement

### `detailed_placement`

Legalizes the global placement:
- Snaps cells to legal sites
- Removes overlaps
- Reports quality metrics

---

## Further Reading

- OpenROAD documentation: Replace module
- "Placement Algorithms and Applications" - Springer
- ISPD placement contest papers
