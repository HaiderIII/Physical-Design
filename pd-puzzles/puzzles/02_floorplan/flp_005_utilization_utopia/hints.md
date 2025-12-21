# Hints for FLP_005: Utilization Utopia

## Hint 1: Reading the Metrics
Look at the design statistics printed before the floorplan step:
```
Design area 15677 um^2
```
This is the area your cells need.

---

## Hint 2: Core Area Calculation
The core area is defined by two corners: (x1, y1) to (x2, y2).
```
core_area = (x2 - x1) × (y2 - y1)
```
With "5 5 45 45": (45-5) × (45-5) = 40 × 40 = 1600 um²

---

## Hint 3: Utilization Formula
```
utilization = (design_area / core_area) × 100%
            = (15677 / 1600) × 100%
            = 979.8% (or ~1000% accounting for adjustments)
```

---

## Hint 4: Target Dimensions
For 60% utilization:
```
required_core = design_area / 0.60
              = 15677 / 0.60
              = 26,128 um²
```
If square: √26128 ≈ 162 um per side

---

## Hint 5: The Key Parameters
Look at line 67-69 in run.tcl:
```tcl
initialize_floorplan -die_area "0 0 50 50" \
                     -core_area "5 5 45 45" \
                     -site FreePDK45_38x28_10R_NP_162NW_34O
```

---

## Hint 6: Maintaining Margins
Keep the same margin relationship (5um on each side):
```tcl
-die_area "0 0 175 175" \
-core_area "5 5 170 170"
```
This gives 165 × 165 = 27,225 um² core area

---

## Hint 7: Solution Check
With the fix, utilization should be:
```
15677 / 27225 × 100% ≈ 57.6%
```
This is within the healthy 50-70% range.
