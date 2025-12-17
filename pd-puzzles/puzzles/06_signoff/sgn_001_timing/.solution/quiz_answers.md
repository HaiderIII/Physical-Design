# Quiz Answers - SGN_001: The Timing Terror

---

## Question 1: Parasitic Estimation

**Why is `estimate_parasitics` necessary before timing signoff?**

✅ **B) It calculates wire RC values for accurate timing**

**Explanation:** After routing, wires have physical properties:
- **Resistance (R)**: Causes IR drop and delay
- **Capacitance (C)**: Causes charging delay

`estimate_parasitics` extracts these values from the routed design so timing analysis reflects real wire delays, not ideal (zero-delay) wires.

---

## Question 2: Timing Without Parasitics

**What happens if you run timing analysis without parasitic estimation?**

✅ **B) Timing looks better than reality (optimistic)**

**Explanation:** Without parasitics:
- Wire delay = 0 (ideal wires)
- Only cell delays are considered
- Slack appears higher than it actually is
- Design may falsely "pass" timing

This is dangerous because the real chip will have worse timing!

---

## Question 3: Setup vs Hold

**What is the difference between setup and hold timing checks?**

✅ **B) Setup checks data arrives before clock, hold checks data stable after clock**

**Explanation:**
```
         ┌──────┐
    D ───┤      │
         │  FF  ├─── Q
  clk ───┤      │
         └──────┘

Setup: D must be stable BEFORE clk edge (setup time)
Hold:  D must remain stable AFTER clk edge (hold time)
```

- **Setup violation**: Data arrives too late
- **Hold violation**: Data changes too early

---

## Question 4: Clock Uncertainty

**What does `set_clock_uncertainty 0.2` represent?**

✅ **B) Margin for jitter and skew variations**

**Explanation:** Clock uncertainty accounts for:
- **Jitter**: Random variation in clock edge timing
- **Skew**: Difference in clock arrival time at different flip-flops
- **PVT variation**: Process, voltage, temperature effects

Adding 0.2ns uncertainty means timing analysis uses a "worst case" clock that can be 0.2ns early or late.

---

## Question 5: Slack Interpretation

**A timing report shows "slack = -0.5 ns". What does this mean?**

✅ **B) Design violates timing by 0.5ns**

**Explanation:**
```
Slack = Required Time - Arrival Time

Positive slack: Design meets timing (margin available)
Zero slack:     Design exactly meets timing
Negative slack: Design VIOLATES timing (must fix!)
```

A slack of -0.5ns means data arrives 0.5ns too late. The design needs optimization (faster cells, shorter paths, or relaxed constraints).

---

## Question 6: Signoff Corners

**Why do production designs analyze timing at multiple corners (slow, typical, fast)?**

✅ **B) To account for manufacturing variations**

**Explanation:** Manufacturing isn't perfect. Transistors vary:

| Corner | Transistors | Temperature | Voltage |
|--------|-------------|-------------|---------|
| Slow | Weak | Hot (125°C) | Low (0.9V) |
| Typical | Nominal | Room (25°C) | Nominal (1.0V) |
| Fast | Strong | Cold (-40°C) | High (1.1V) |

- **Setup** is worst at slow corner (paths are slowest)
- **Hold** is worst at fast corner (paths are fastest)

Multi-corner analysis ensures the chip works across all manufacturing variations.

---

## Score Interpretation

| Score | Level | Recommendation |
|-------|-------|----------------|
| 6/6 | Expert | You understand timing signoff perfectly |
| 4-5/6 | Good | Review the concepts you missed |
| 3/6 | Fair | Re-read PROBLEM.md and hints.md |
| <3/6 | Needs Work | Study timing analysis fundamentals |

---

## Key Takeaways

1. **Always estimate parasitics** before timing signoff
2. **Negative slack = violation** that must be fixed
3. **Setup and hold** are different timing checks
4. **Clock uncertainty** adds margin for real-world variation
5. **Multiple corners** ensure chip works despite manufacturing variation

---

**Congratulations!** You've completed the timing signoff puzzle!
