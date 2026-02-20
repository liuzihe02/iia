# Experiment 3B2: FPGA Programming and Testing

This markdown file contains basic scaffolding for how to write our short lab report in latex. The entire report should not exceed 5 pages long.\

> This report is in SHORT_COURSEWORK

Although the emphasis is on a succinct report, a good write-up should clearly explain:
what each part of the experiment sought to explore;
what you found out, and what precautions you needed; and
brief conclusions about each main result.

## Traffic Light Controller (TLC) Design

### Problem Setup

### State Machine Design
<!-- Present and explain the state diagram (Figure 5) and state table (Table 1) -->
<!-- Describe what each state represents (G, Y, R) and the transition conditions -->

Draw an actual state diagram

**State Table:**

| State | Next State (Reset) | Next State (Request) | Next State (5s) | Next State (10s) | Veh. GREEN | Veh. YELLOW | Veh. RED | Ped. GREEN | Ped. RED |
|-------|--------------------|----------------------|-----------------|------------------|------------|-------------|----------|------------|----------|
| G     | G                  | Y                    |                 |                  | 1          | 0           | 0        | 0          | 1        |
| Y     | G                  |                      | R               |                  | 0          | 1           | 0        | 0          | 1        |
| R     | G                  |                      |                 | G                | 0          | 0           | 1        | 1          | 0        |

### Verilog Implementation
<!-- Paste and explain your Verilog code here -->
<!-- Comment on key design choices: clock divider, state encoding, output logic -->

```verilog
// Paste your tlc.v code here
```

<!-- Explain:
     - How the 50 MHz clock is divided (counter threshold values for 5s and 10s)
     - How states are encoded (2-bit: G=0, Y=1, R=2)
     - Active-low reset behaviour
     - Output vector mapping [4:0] -->

### Compilation Results

<!-- Report the Compiler Flow Summary figures -->

| Resource       | Count |
|----------------|-------|
| Logic Elements |       |
| Registers      |       |
| Pins           |       |

<!-- Comment on whether these numbers seem reasonable for the circuit complexity -->

---

## Pin Assignment

<!-- Comment on the configurability of pin assignments in Quartus -->

Pin Assignments

Signal      | Pin       | Component
------------|-----------|------------------
clk         | PIN_AF14  | 50 MHz Clock
request     | PIN_AA15  | KEY1 (Push-button[1])
reset       | PIN_AA14  | KEY0 (Push-button[0])
output[0]   | PIN_V16   | LED0 (LEDR0)
output[1]   | PIN_V17   | LED2 (LEDR2)
output[2]   | PIN_W17   | LED4 (LEDR4)
output[3]   | PIN_Y19   | LED6 (LEDR6)
output[4]   | PIN_W21   | LED8 (LEDR8)

<!-- Note: all on-board LEDs are RED; comment on this limitation and how GREEN/YELLOW are represented -->

---

## Testing

<!-- Describe the testing procedure -->
<!-- Verify behaviour against Table 1 for all input combinations -->

| Initial State | Input Applied | Expected Next State | Observed Behaviour | Pass/Fail |
|--------------|---------------|---------------------|--------------------|-----------|
| G            | request       | Y (5s timer)        |                    |           |
| Y            | (timer 5s)    | R (10s timer)       |                    |           |
| R            | (timer 10s)   | G                   |                    |           |
| Any          | reset         | G                   |                    |           |

<!-- Comment on any discrepancies or observations during testing -->

## Improved Circuit

### Design Motivation
<!-- Describe the problem: continuous request can permanently block the vehicle lane -->
<!-- Explain your solution: 10-second vehicle GREEN lockout after completing a pedestrian request -->

### Updated State Machine
<!-- Updated state diagram / description of new state(s) or transitions added -->

### 6.3 Verilog Implementation

```verilog
// Paste your improved tlc.v code here
```

<!-- Explain key changes from the original design -->

### Testing
<!-- Describe how you tested the lockout behaviour -->
<!-- Verify that a second request during the 10s lockout window is correctly deferred -->

---

## Conclusions

<!-- Brief conclusions for each main result:
     - Did the basic TLC circuit behave correctly against Table 1?
     - Were the resource usage figures as expected for the circuit complexity?
     - Did the improved circuit successfully prevent lane blocking?
     - Any observations about FPGA design methodology, Verilog vs schematic entry, or JTAG programming? -->

---

## Appendix

### Compilation Report Screenshot
<!-- Screenshot of Quartus Compiler Flow Summary (logic elements, registers, pins) -->

### Pin Assignment Table Screenshot
<!-- Screenshot of Assignment Editor showing all pin mappings -->

### Board Photos
<!-- Photos of FPGA board in each state (G, Y, R) showing LED outputs -->

### Testbench Code