# Hints - RTE_002 The Adjustment Agony

Try to solve the puzzle yourself first! Use these hints only if stuck.

---

## Hint 1 - Where to Look

The bug is in the **global routing configuration** section (Step 8).

Look for `set_global_routing_layer_adjustment` commands.

---

## Hint 2 - Understanding Layer Adjustments

Layer adjustment values work like this:
- `0.0` = Full capacity available (0% blocked)
- `0.5` = Half capacity (50% blocked)
- `1.0` = No capacity (100% blocked)

Higher adjustment = less routing resources on that layer.

---

## Hint 3 - The Pattern

Look at the current adjustment values:
```tcl
met1: 0.2  (mostly available)
met2: 0.3  (mostly available)
met3: 0.5  (half available)
met4: 0.8  (mostly blocked)
met5: 0.9  (almost fully blocked)
```

Is this the right pattern? Which layers are typically congested?

---

## Hint 4 - Physical Reality

In real chips:
- **Lower layers (met1, met2)**: Very congested
  - Cell pins on met1
  - Local interconnect on met1-met2
  - High track density but many obstructions

- **Upper layers (met4, met5)**: Less congested
  - Fewer obstructions
  - Available for long signal routes
  - Should be kept available!

---

## Hint 5 - The Fix

The adjustments are **inverted**. You should:
1. Use HIGH adjustment (0.8-1.0) for lower layers (met1, met2)
2. Use LOW adjustment (0.0-0.3) for upper layers (met4, met5)

Example correct values:
```tcl
set_global_routing_layer_adjustment met1 0.9
set_global_routing_layer_adjustment met2 0.7
set_global_routing_layer_adjustment met3 0.4
set_global_routing_layer_adjustment met4 0.2
set_global_routing_layer_adjustment met5 0.1
```

---

## Still Stuck?

Check `.solution/EXPLANATION.md` for the full explanation.
