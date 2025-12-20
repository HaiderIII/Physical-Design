# Congestion Catastrophe

## Difficulty: Expert
## PDK: Sky130HD

---

## Background

You're working on a high-performance crossbar switch for a Network-on-Chip (NoC) design. The crossbar connects 4 input ports to 4 output ports, with each port handling 8-bit data. This architecture creates a complex interconnect pattern where any output can receive data from any input.

The design has passed synthesis, floorplanning, placement, and CTS. Now you're running global routing, but the router is reporting severe congestion and overflow issues.

---

## The Problem

Run the flow:
```bash
openroad run.tcl
```

The routing step fails or reports significant overflow. The crossbar's crossing wire pattern requires careful layer allocation, but something is blocking the necessary routing resources.

---

## Your Task

1. Analyze the routing configuration in `run.tcl`
2. Understand which layers are available for routing
3. Identify why congestion is occurring
4. Fix the layer adjustment strategy

---

## Success Criteria

- Global routing completes with 0 overflow
- No routing DRC errors
- Design meets timing constraints

---

## Hints

See `hints.md` for progressive hints if you get stuck.

---

## Key Concepts

- Layer adjustment values and their meaning
- Routing resource allocation strategy
- Lower vs upper metal layer characteristics
- Impact of layer blocking on congestion
