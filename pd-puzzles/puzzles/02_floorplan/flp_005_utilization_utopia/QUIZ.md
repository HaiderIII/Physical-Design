# FLP_005: Utilization Utopia - Quiz

Test your understanding of this puzzle.

---

## Question 1: Understanding the Error
What does "Utilization 1123.680% exceeds 100%" mean?

- [ ] A) The design uses 11x more power than allowed
- [X] B) The cells require 11x more area than available in the core
- [ ] C) There are 11x too many timing violations
- [ ] D) The routing congestion is 11x above threshold

## Question 2: Design Area
The log shows "Design area 15677 um^2". What defines this value?

- [ ] A) The die_area parameter in initialize_floorplan
- [X] B) The total area of all standard cells after synthesis
- [ ] C) The core_area parameter in initialize_floorplan
- [ ] D) The routing resources required

## Question 3: Calculating Core Area
What is the current core area with core_area "5 5 45 45"?

- [ ] A) 2500 um² (50 × 50)
- [X] B) 1600 um² (40 × 40)
- [ ] C) 2025 um² (45 × 45)
- [ ] D) 900 um² (30 × 30)

## Question 4: Required Core Area
For 60% utilization with 15677 um² design area, what core area is needed?

- [ ] A) ~9,400 um²
- [ ] B) ~15,700 um²
- [X] C) ~26,100 um²
- [ ] D) ~31,400 um²

## Question 5: Die vs Core Relationship
In the floorplan, what is the difference between die_area and core_area?

- [ ] A) Die area is for routing, core area is for cells
- [X] B) Core area is inside die area, leaving margin for I/O and power rings
- [ ] C) Die area defines timing, core area defines placement
- [ ] D) They are synonyms with different syntax

## Question 6: Margin Calculation
With die_area "0 0 50 50" and core_area "5 5 45 45", what is the margin on each side?

- [ ] A) 2.5 um
- [X] B) 5 um
- [ ] C) 10 um
- [ ] D) 45 um

## Question 7: The Fix
To fix this puzzle, you need to:

- [ ] A) Reduce the design size with optimization
- [X] B) Increase die_area and core_area dimensions
- [ ] C) Change the PDK to one with smaller cells
- [ ] D) Remove some pipeline stages

---

## Scoring

| Score | Level |
|-------|-------|
| 7/7   | Master |
| 5-6/7 | Advanced |
| 3-4/7 | Intermediate |
| 0-2/7 | Review floorplan fundamentals |
