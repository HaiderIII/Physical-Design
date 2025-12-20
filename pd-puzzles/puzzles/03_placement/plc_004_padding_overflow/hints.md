# Hints - Padding Overflow

## Hint 1: Understanding the Error
<details>
<summary>Click to reveal</summary>

The error `DPL-0036 Detailed placement failed` indicates that some cells cannot be placed in legal positions.

This happens when there is not enough room in the rows to fit all cells with their required spacing.
</details>

## Hint 2: What is Cell Padding?
<details>
<summary>Click to reveal</summary>

Cell padding adds extra space around each cell during placement. This is used for:
- Ensuring metal density requirements
- Providing space for fill cells
- Reducing routing congestion
- Meeting manufacturing DRC rules

The command `set_placement_padding` controls this spacing.
</details>

## Hint 3: Padding vs Available Space
<details>
<summary>Click to reveal</summary>

Padding effectively increases the "footprint" of each cell during placement.

If you have 64 cells and add 10 sites of padding on each side, you're adding:
- 64 cells × (10 left + 10 right) = 1280 extra sites required!

Does the core area have enough rows to accommodate this?
</details>

## Hint 4: Calculate the Impact
<details>
<summary>Click to reveal</summary>

Look at the padding values in the script:
```tcl
set_placement_padding -global -left X -right Y
```

Each cell in Sky130HD is about 0.46um per site. With the core area ~40um wide:
- Available sites per row ≈ 40 / 0.46 ≈ 86 sites
- Number of rows ≈ 14

Total site capacity ≈ 86 × 14 ≈ 1204 sites

Now calculate how much space the padded cells need...
</details>

## Hint 5: The Math Problem
<details>
<summary>Click to reveal</summary>

With 64 cells and padding of 10 left + 10 right:
- Each cell needs its own width + 20 sites of padding
- Average cell width ≈ 2-4 sites
- Effective width per cell ≈ 3 + 20 = 23 sites
- Total needed ≈ 64 × 23 = 1472 sites

But available capacity ≈ 1204 sites

The cells simply don't fit!
</details>

## Hint 6: Solution Direction
<details>
<summary>Click to reveal</summary>

The padding values are too aggressive for the available core area. You have two options:

1. **Reduce padding** to reasonable values (1-2 sites is typical for Sky130HD)
2. **Increase core area** to accommodate the padding

For this puzzle, focus on fixing the padding values to be appropriate for the technology.
</details>
