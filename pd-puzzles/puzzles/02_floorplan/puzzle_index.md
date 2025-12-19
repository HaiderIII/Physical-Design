# 02_floorplan Puzzles

## Puzzle List

| ID | Name | Level | PDK | Status |
|----|------|-------|-----|--------|
| flp_001 | The Impossible Floorplan | Beginner | Nangate45 | ✅ |
| flp_002 | The Halo Headache | Intermediate | Sky130 | ✅ |
| flp_003 | Density Disaster | Advanced | ASAP7 | ✅ |

## Skills Covered

- Die and core area sizing
- Utilization calculations
- IO placement
- **Macro placement with blockages**
- **Halo/keepout region definition**
- **Analog-digital isolation**
- **Density targets for advanced nodes**
- **IO perimeter requirements**

## Progression

```
flp_001 (Nangate45) ──► flp_002 (Sky130) ──► flp_003 (ASAP7)
    │                       │                    │
    │                       │                    │
    ▼                       ▼                    ▼
 Die area sizing       Macro blockages      Density targets
 Utilization math      Halo placement       IO perimeter
```

## Key Concepts

### Die vs Core Area
- **Die Area**: Total chip area including pads
- **Core Area**: Placeable area for standard cells
- **Margins**: Space for IO ring (typically 2-5um)

### Utilization
```
Utilization = Cell Area / Core Area

Typical ranges:
- Simple designs: 60-70%
- Complex designs: 40-60%
- High-performance: 30-50%
```

### Placement Blockages (flp_002)
```tcl
# Create keepout region around macros
create_blockage -region {x1 y1 x2 y2}

# Calculation: macro_position - halo to macro_position + size + halo
```
