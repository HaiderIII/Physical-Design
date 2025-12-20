# Hints - Skew Spiral

## Hint 1: Understanding the Warning
<details>
<summary>Click to reveal</summary>

The warning `EST-0027: no estimated parasitics` indicates that wire resistance and capacitance values are not properly configured.

Without accurate wire RC, the CTS engine cannot correctly estimate:
- Wire delays
- Buffer drive requirements
- Clock skew
</details>

## Hint 2: Wire RC in CTS
<details>
<summary>Click to reveal</summary>

Clock Tree Synthesis needs to know the wire RC characteristics to:
- Size clock buffers correctly
- Estimate insertion delay
- Balance clock paths
- Calculate skew

The `set_wire_rc` command provides this information.
</details>

## Hint 3: Clock vs Signal Wire RC
<details>
<summary>Click to reveal</summary>

In OpenROAD, you can specify different wire RC for:
- Signal nets: `set_wire_rc -layer <layer>`
- Clock nets: `set_wire_rc -clock -layer <layer>`

Clock nets typically use higher metal layers for lower RC.
</details>

## Hint 4: Layer Selection
<details>
<summary>Click to reveal</summary>

For Sky130HD clock routing:
- met3 or met4 are good choices for clock
- Higher metal layers have lower resistance
- Lower capacitance per unit length

The command needs to specify `-clock` flag for CTS.
</details>

## Hint 5: Where to Add
<details>
<summary>Click to reveal</summary>

The `set_wire_rc` command should be added BEFORE `clock_tree_synthesis`.

This allows CTS to use the correct RC values when building the tree.
</details>

## Hint 6: Solution
<details>
<summary>Click to reveal</summary>

Add after floorplan creation, before placement:
```tcl
set_wire_rc -layer met2           # For signal nets
set_wire_rc -clock -layer met3    # For clock nets
```

Both commands are needed - signal RC for general timing, clock RC for CTS.
</details>
