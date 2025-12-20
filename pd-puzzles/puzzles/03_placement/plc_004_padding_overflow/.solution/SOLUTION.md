# Solution - Padding Overflow

## The Bug

In `run.tcl`, line 66:
```tcl
set_placement_padding -global -left 10 -right 10
```

A padding of 10 sites on each side is far too aggressive for the available core area.

## The Fix

Change to reasonable padding values:
```tcl
set_placement_padding -global -left 1 -right 1
```

## Explanation

### What is Cell Padding?

Cell padding reserves extra space around each cell during placement. It's used for:
- Meeting metal density requirements
- Providing room for fill cells
- Reducing routing congestion
- Manufacturing DRC rules compliance

### Why 10 Sites Fails

Let's do the math:

**Available Space:**
- Core area: 40um × 40um
- Site width in Sky130HD: ~0.46um
- Sites per row: 40 / 0.46 ≈ 86 sites
- Number of rows: 14
- Total capacity: ~1204 sites

**Required Space with Padding:**
- Number of cells: 64
- Average cell width: ~3 sites
- Padding per cell: 10 left + 10 right = 20 sites
- Effective width per cell: 3 + 20 = 23 sites
- Total needed: 64 × 23 = 1472 sites

**1472 sites needed > 1204 sites available = FAILURE**

### Typical Padding Values

| Technology | Typical Padding |
|------------|-----------------|
| Sky130HD (130nm) | 0-2 sites |
| ASAP7 (7nm) | 1-4 sites |
| Advanced nodes | Varies by cell type |

### When to Use Different Padding

- **No padding (0)**: Simple designs, plenty of space
- **1-2 sites**: Standard practice, balances density and routability
- **3-5+ sites**: Special cells (clock buffers, high-drive), congested areas
- **10+ sites**: Usually a mistake or very specific requirements

### Real-World Considerations

In production flows:
- Padding is often specified per-cell-type, not globally
- Critical cells (clock, scan) may have more padding
- Padding affects utilization calculations
- Always verify padding doesn't exceed available capacity

## Quiz Answers

1. **B** - To ensure spacing for metal density, fill cells, and routing
2. **C** - Number of sites
3. **B** - Cells cannot find legal positions within available space
4. **D** - 1280 sites (64 cells × 20 sites padding each)
5. **B** - 1-2 sites
6. **C** - Both A and B
7. **B** - Padding of 10 sites left/right was too aggressive for the core area
