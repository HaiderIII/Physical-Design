# Quiz Answers - FLP_001

---

## Question 1: Die Area Calculation

**Correct Answer: C) 35 x 35 um**

Calculation:
1. Cell area = 500 um^2
2. Target utilization = 60% = 0.60
3. Required core area = 500 / 0.60 = 833.3 um^2
4. Core side = sqrt(833.3) = 28.9 um ≈ 29 um
5. Die side = 29 + 3 + 3 (margins) = 35 um

---

## Question 2: Understanding Utilization

**Correct Answer: C) 95% utilization is excellent and should always be the target**

This is FALSE because:
- 95% utilization leaves almost no room for routing
- Clock tree synthesis adds buffers that need space
- High utilization causes congestion and timing issues
- Typical targets are 40-70% depending on design complexity

---

## Question 3: Core vs Die Area

**Correct Answer: A) 5 um on each side**

Explanation:
- Die goes from 0 to 100 (100 um wide)
- Core goes from 5 to 95 (90 um wide)
- Margin on left: 5 - 0 = 5 um
- Margin on right: 100 - 95 = 5 um
- Same for top/bottom

---

## Question 4: Placement Failure

**Correct Answers: A, C, and D**

- **A) Increase die/core area** - YES, gives more room for cells
- **B) Reduce target utilization parameter** - NO, this doesn't change physical space available
- **C) Remove cells from the design** - YES (if possible), reduces area needed
- **D) Use a different PDK with smaller cells** - YES, smaller cells = less area needed

Note: Option B changes placement algorithm behavior but doesn't solve the fundamental space problem.

---

## Question 5: OpenROAD Command

**Correct Answer: C) -utilization**

The `-utilization` option tells OpenROAD the target utilization percentage. The tool then:
1. Calculates total cell area from the netlist
2. Divides by utilization to get required core area
3. Adds margins to determine die area
4. Creates the floorplan automatically

---

## Question 6: Real-World Scenario

**Correct Answer: B) Placement will likely fail with utilization errors**

When cell count increases 5x but die area stays the same:
- Cell area increases ~5x
- Available core area is unchanged
- Utilization jumps dramatically (potentially >100%)
- Placer fails with "utilization exceeds 100%" error

This is exactly the bug in FLP_001!

---

## Key Takeaways

1. **Always calculate required area** before setting die dimensions
2. **Use -utilization** for automatic sizing when possible
3. **Target 50-70% utilization** for most designs
4. **Leave margins** for IO ring (typically 2-5 um)
5. **Check error messages** - they tell you exactly what's wrong
