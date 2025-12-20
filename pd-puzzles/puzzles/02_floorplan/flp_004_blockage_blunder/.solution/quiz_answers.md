# Quiz Answers - FLP_004: Blockage Blunder

## Answers

1. **B** - To prevent cells from being placed in a specific region
2. **C** - Within the core area boundaries
3. **C** - It causes an error or undefined behavior
4. **B** - Reserving space for analog IP or macros
5. **B** - Lower-left and upper-right corners
6. **C** - (20, 20) to (80, 80) - fully within (10,10)-(90,90)
7. **B** - For future analog IP or power management blocks

## Key Concepts

### Blockage Types

| Type | Command | Purpose |
|------|---------|---------|
| Placement | `create_blockage` | Prevent cell placement |
| Routing | `create_obstruction` | Prevent routing on specific layers |

### Coordinate Validation

```
Core: (core_llx, core_lly) to (core_urx, core_ury)

Valid blockage:
  blockage_llx >= core_llx
  blockage_lly >= core_lly
  blockage_urx <= core_urx
  blockage_ury <= core_ury
```

### Common Mistakes

1. Extending blockage outside core bounds
2. Using die coordinates instead of core coordinates
3. Forgetting to account for core margins
