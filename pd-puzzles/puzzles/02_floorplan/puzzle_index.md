# 02_floorplan Puzzles

## Puzzle List

| ID | Name | Level | PDK | Status |
|----|------|-------|-----|--------|
| flp_001 | The Impossible Floorplan | Beginner | Nangate45 | ✅ |
| flp_002 | The Halo Headache | Intermediate | Sky130 | ✅ |
| flp_003 | Density Disaster | Advanced | ASAP7 | ✅ |
| flp_004 | Blockage Blunder | Expert | Sky130HD | ✅ |

## Skills Covered

- Die and core area sizing
- Utilization calculations
- IO placement
- **Macro placement with blockages**
- **Halo/keepout region definition**
- **Analog-digital isolation**
- **Density targets for advanced nodes**
- **IO perimeter requirements**
- **Placement blockage coordinate validation**

## Progression

```
flp_001 (Nangate45) ──► flp_002 (Sky130) ──► flp_003 (ASAP7) ──► flp_004 (Expert)
    │                       │                    │                    │
    ▼                       ▼                    ▼                    ▼
 Die area sizing       Macro blockages      Density targets     Blockage coords
 Utilization math      Halo placement       IO perimeter        IP reservation
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

### Placement Blockages
```tcl
# Create keepout region for analog IP
create_blockage -region {x1 y1 x2 y2}

# Blockage must be WITHIN core area!
# x1 >= core_llx, y1 >= core_lly
# x2 <= core_urx, y2 <= core_ury
```
