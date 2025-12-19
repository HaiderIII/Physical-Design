# CTS_003 - Sink Shuffle

## Difficulty: Advanced

## PDK: ASAP7 (7nm)

## Problem Description

You're running Clock Tree Synthesis on an 8-stage pipeline at 1.5 GHz using ASAP7. The CTS completes but produces a clock tree with **high skew** because sink clustering is disabled and the diameter is too large.

At advanced nodes (7nm), sink clustering is critical:
- Groups nearby flip-flops into clusters
- Each cluster gets its own buffer
- Reduces local skew within clusters
- Controls wire capacitance per buffer

## Symptoms

When you run the puzzle without fixing it:
```
>>> WARNING: Sink clustering is DISABLED! <<<
    This will cause high skew at 7nm frequencies!
```

## The Bug

The script has sink clustering disabled and diameter too large:
```tcl
set enable_clustering false    ;# <-- BUG! Should be true
set cluster_diameter  200      ;# <-- BUG! Too large (should be 20-50)
```

## Your Task

1. Find the sink clustering configuration in `run.tcl`
2. Enable sink clustering
3. Set an appropriate cluster diameter for ASAP7
4. Run the script until CTS passes

## Hints

<details>
<summary>Hint 1: What is sink clustering?</summary>

Sink clustering groups clock sinks (flip-flops) by physical proximity:

```
Without clustering:          With clustering:
     [Root]                      [Root]
    /||||||\                    /      \
   / |||||| \                [Buf1]  [Buf2]
  FF FF FF FF FF FF          / | \    / | \
  (one buffer, many sinks)  FF FF FF FF FF FF
                            (cluster) (cluster)
```

Each cluster has similar wire lengths = lower skew.
</details>

<details>
<summary>Hint 2: Why does diameter matter?</summary>

The `sink_clustering_max_diameter` sets the maximum span of a cluster:
- 200 um: Too large - sinks far apart, different wire delays
- 20-50 um: Good for 7nm - nearby sinks, similar delays
- 5 um: Too small - too many buffers, wasted area/power
</details>

<details>
<summary>Hint 3: Recommended values</summary>

```tcl
set enable_clustering true
set cluster_diameter  30    ;# 30 um is good for ASAP7
```
</details>

## Success Criteria

The CTS passes when:
- Sink clustering is enabled
- Cluster diameter is ≤ 100 um (ideally 20-50)

## Files

- `run.tcl` - Main script with the bug
- `resources/pipeline.v` - 8-stage pipeline netlist
- `resources/constraints.sdc` - Timing constraints (1.5 GHz)

## Learning Objectives

- Understand sink clustering in CTS
- Learn the relationship between cluster size and skew
- Configure CTS for advanced nodes
