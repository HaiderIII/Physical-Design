# Quiz Answers - PLC_001

---

## Question 1: Density Definition

**Correct Answer: B) Pack cells to fill 70% of available placement space**

The `-density` parameter tells the global placer how tightly to pack cells.
- 0.70 means fill 70% of available space with cells
- The remaining 30% is left as whitespace for routing and optimization

---

## Question 2: Delta HPWL

**Correct Answer: B) Wirelength increased 35% during legalization**

Delta HPWL = (legalized_HPWL - original_HPWL) / original_HPWL

This measures how much cells had to move during detailed placement (legalization).
A high value (35%) indicates:
- Global placement was too aggressive
- Cells had to spread out to find legal sites
- Resulting placement is sub-optimal

---

## Question 3: High Density Problems

**Correct Answers: A, B, and D**

- **A) Routing congestion** - YES, less space for wires
- **B) Increased wirelength after legalization** - YES, cells must spread out
- **C) Faster placement runtime** - NO, actually can be slower due to congestion
- **D) Difficulty inserting clock buffers later** - YES, no room for CTS

---

## Question 4: Density Selection

**Correct Answer: D) 0.45 (relaxed for routing)**

For complex routing and tight timing:
- Need space for routing detours
- Need room for optimization buffers
- Lower density = shorter wires = better timing
- 0.45-0.50 is appropriate for timing-critical designs

---

## Question 5: Metrics Interpretation

**Correct Answer: A) Option A**

Option A has:
- Lower delta HPWL (12% vs 28%)
- Lower average displacement (0.9um vs 2.4um)

Both metrics indicate Option A had a better global placement that required less adjustment during legalization.

---

## Question 6: Density vs Utilization

**Correct Answer: B) Cells are packed tightly within the 60% utilized area**

Key insight: Utilization and density are different!

- **Utilization** (floorplan): How much of core area contains cells
- **Density** (placement): How tightly cells are packed during placement

With 60% utilization and 0.90 density:
- The 60% of area containing cells is packed to 90% capacity
- Creates local hotspots within the utilized region
- Can still cause congestion even though global utilization is low

---

## Key Takeaways

1. **Density affects placement quality**, not area
2. **Lower density = better routing** in most cases
3. **Monitor delta HPWL** to judge placement quality
4. **Don't confuse utilization with density**
5. **60-70% density** is a good default for most designs
