# Quiz - Padding Overflow

Test your understanding of cell padding and placement constraints.

---

## Question 1: Purpose of Cell Padding
What is the primary purpose of cell padding in placement?

- [ ] A) To make cells look nicer in the layout
- [X] B) To ensure spacing for metal density, fill cells, and routing
- [ ] C) To increase the chip size
- [ ] D) To slow down the design

## Question 2: Padding Units
In OpenROAD's set_placement_padding command, what unit is padding specified in?

- [ ] A) Microns (um)
- [ ] B) Nanometers (nm)
- [X] C) Number of sites
- [ ] D) Percentage of cell width

## Question 3: Placement Failure Cause
What causes detailed placement to fail with "DPL-0036"?

- [ ] A) Invalid PDK files
- [X] B) Cells cannot find legal positions within available space
- [ ] C) Clock is not defined
- [ ] D) Power grid is missing

## Question 4: Padding Impact
If you add -left 10 -right 10 padding to 64 cells, how many extra sites are consumed?

- [ ] A) 10 sites
- [ ] B) 20 sites
- [ ] C) 640 sites
- [X] D) 1280 sites

## Question 5: Typical Padding Values
What is a typical cell padding value for mature technology nodes like Sky130HD?

- [ ] A) 0 sites (no padding)
- [X] B) 1-2 sites
- [ ] C) 10-20 sites
- [ ] D) 100+ sites

## Question 6: Fixing Padding Issues
If placement fails due to excessive padding, what are valid solutions?

- [ ] A) Reduce padding values
- [ ] B) Increase core area
- [X] C) Both A and B
- [ ] D) Disable detailed placement

## Question 7: The Bug
What was the specific problem in this puzzle?

- [ ] A) No padding was set
- [X] B) Padding of 10 sites left/right was too aggressive for the core area
- [ ] C) Wrong site type was used
- [ ] D) Global placement was disabled

---

## Answers
Complete this section after solving the puzzle:

Q1: [ ]  Q2: [ ]  Q3: [ ]  Q4: [ ]  Q5: [ ]  Q6: [ ]  Q7: [ ]
