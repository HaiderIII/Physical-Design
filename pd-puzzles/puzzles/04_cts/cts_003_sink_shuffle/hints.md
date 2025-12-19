# Hints - CTS_003: Sink Shuffle

## Hint 1: Understanding the Warning

The script tells you exactly what's wrong:
```
>>> WARNING: Sink clustering is DISABLED! <<<
    This will cause high skew at 7nm frequencies!
```

At 1.5 GHz (667ps period), even small skew differences matter.

---

## Hint 2: What is Sink Clustering?

Sink clustering groups flip-flops by location:

```
Without clustering:
           [Root Buffer]
          /  |  |  |  |  \
         /   |  |  |  |   \
        FF  FF  FF  FF  FF  FF
        ↑                    ↑
        Short wire           Long wire
        = fast              = slow
                    ↓
              HIGH SKEW!

With clustering:
           [Root Buffer]
           /            \
     [Buf A]            [Buf B]
      / | \              / | \
    FF FF FF           FF FF FF
    (Cluster 1)        (Cluster 2)

    Within each cluster, wires are similar length!
```

---

## Hint 3: The Cluster Diameter Parameter

`sink_clustering_max_diameter` controls cluster size:

| Value | Effect |
|-------|--------|
| 200 um | Too large - distant FFs grouped together |
| 50 um | Good - reasonable cluster size |
| 30 um | Better for 7nm - tight clusters |
| 5 um | Too small - too many buffers |

For ASAP7 at 1.5 GHz: use 20-50 um.

---

## Hint 4: The Fix Location

Look for these lines in `run.tcl`:
```tcl
set enable_clustering false    ;# <-- FIX THIS
set cluster_diameter  200      ;# <-- FIX THIS
```

---

## Hint 5: Recommended Values

For ASAP7 (7nm) at GHz frequencies:
```tcl
set enable_clustering true
set cluster_diameter  30    ;# 30 um is a good choice
```

---

## Hint 6: Why This Matters at 7nm

At 7nm with GHz clocks:
- Wire RC delays are significant
- Small capacitance differences = measurable skew
- 1ps skew can be 0.15% of your clock period
- Proper clustering keeps skew under control

---

## Solution Summary

1. Change `enable_clustering` from `false` to `true`
2. Change `cluster_diameter` from `200` to `30` (or any value 20-50)
3. Run the script - it should pass
