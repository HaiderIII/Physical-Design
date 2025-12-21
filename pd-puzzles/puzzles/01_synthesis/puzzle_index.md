# 01_synthesis Puzzles

## Puzzle List

| ID | Name | Level | PDK | Status |
|----|------|-------|-----|--------|
| syn_001 | The Missing Library | Beginner | Nangate45 | ✅ |
| syn_002 | The Corner Chaos | Intermediate | Sky130HD | ✅ |
| syn_003 | The Voltage Vortex | Advanced | ASAP7 | ✅ |
| syn_004 | Forbidden Cells | Expert | Sky130HD | ✅ |
| syn_005 | False Path Fiasco | Master | Nangate45 | ✅ |

## Skills Covered

- TCL file path management
- PDK file structure (Liberty, LEF)
- Library loading error debugging
- **Multi-corner PVT timing analysis**
- **Setup vs Hold corner selection**
- **Liberty file naming conventions**
- **Multi-Vt concepts (RVT, LVT, SLVT)**
- **Leakage vs speed trade-offs**
- **Library-netlist matching**
- **Forbidden cell detection (dont_use)**
- **Netlist verification workflow**
- **False path constraints and wildcards**
- **SDC debugging for hidden timing issues**

## Progression

```
syn_001 (Nangate45) ──► syn_002 (Sky130HD) ──► syn_003 (ASAP7) ──► syn_004 (Expert) ──► syn_005 (Master)
    │                       │                      │                    │                    │
    ▼                       ▼                      ▼                    ▼                    ▼
 Path setup            Multi-corner            Multi-Vt          Forbidden cells      False paths
 PDK basics            PVT signoff          Power analysis      Netlist QA           SDC wildcards
```
