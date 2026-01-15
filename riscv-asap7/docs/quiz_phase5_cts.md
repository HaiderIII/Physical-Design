# Quiz Phase 5: Clock Tree Synthesis (CTS)

## Key Concepts
- Clock distribution network
- Clock skew and latency
- Buffer insertion
- Hold/Setup timing

---

## Questions

### Q1: What is the main goal of Clock Tree Synthesis?

- [ ] a) To reduce power consumption
- [X] b) To distribute the clock signal with minimal skew to all sequential elements
- [ ] c) To increase clock frequency
- [ ] d) To reduce the number of flip-flops

---

### Q2: What is "clock skew"?

- [ ] a) The clock frequency variation
- [X] b) The difference in clock arrival time between two flip-flops
- [ ] c) The clock duty cycle
- [ ] d) The clock jitter

---

### Q3: Why do we insert buffers in the clock tree?

- [ ] a) To reduce area
- [X] b) To drive the large capacitive load of many flip-flop clock pins
- [ ] c) To increase clock frequency
- [ ] d) To reduce power

---

### Q4: What is "clock latency"?

- [ ] a) The clock period
- [X] b) The time from clock source to a flip-flop clock pin
- [ ] c) The setup time of flip-flops
- [ ] d) The hold time of flip-flops

---

### Q5: What type of timing violation is most affected by clock skew?

- [ ] a) Setup violations only
- [ ] b) Hold violations only
- [X] c) Both setup and hold violations
- [ ] d) Neither

---

## Score

| Correct Answers | Level |
|-----------------|-------|
| 5/5 | Excellent! |
| 4/5 | Very Good |
| 3/5 | Good |
| 2/5 | Review needed |
| 0-1/5 | Re-read the course |

---

## Phase 5 Summary

```
Clock Tree Structure:
                    ┌─────┐
        Clock In ───│ Root│
                    │ Buf │
                    └──┬──┘
           ┌──────────┼──────────┐
           │          │          │
        ┌──┴──┐    ┌──┴──┐    ┌──┴──┐
        │Buf 1│    │Buf 2│    │Buf 3│     ← Level 1
        └──┬──┘    └──┬──┘    └──┬──┘
           │          │          │
      ┌────┴────┐ ┌───┴───┐ ┌───┴───┐
      │         │ │       │ │       │
    ┌─┴─┐    ┌──┴┐│┌──┐  ┌┴─┐    ┌─┴─┐
    │FF1│    │FF2│││FF3│  │FF4│   │FF5│   ← Flip-flops
    └───┘    └───┘│└───┘  └───┘   └───┘

Key Metrics:
- Skew: max(arrival_time) - min(arrival_time)
- Latency: time from clock source to FF
- Insertion delay: latency added by buffers

Timing Impact:
- Setup: T_clk > T_data + T_setup - T_skew
- Hold: T_hold < T_data + T_skew
```

## Useful Commands

```tcl
# Configure clock tree synthesis
clock_tree_synthesis -buf_list {BUFx4_ASAP7_75t_R} -root_buf BUFx4_ASAP7_75t_R

# Report clock skew
report_clock_skew

# Estimate parasitics
estimate_parasitics -placement

# Report timing
report_checks -path_delay max
report_checks -path_delay min
```
