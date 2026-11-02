# D Flip-Flop with Asynchronous Reset (Verilog HDL)

A hardware implementation and verification of a positive-edge-triggered **D Flip-Flop with Active-High Asynchronous Reset** written in Verilog HDL and simulated using Mentor Graphics **ModelSim**.

---

## Table of Contents
- [Overview](#overview)
- [Module Specifications](#module-specifications)
  - [Port List](#port-list)
  - [Truth Table](#truth-table)
- [Project Structure](#project-structure)
- [RTL Implementation](#rtl-implementation)
- [Testbench & Verification](#testbench--verification)
  - [Stimulus Sequence](#stimulus-sequence)
  - [Simulation Output](#simulation-output)
- [How to Run Simulation](#how-to-run-simulation)
  - [Using ModelSim / QuestaSim (CLI / GUI)](#using-modelsim--questasim-cli--gui)
  - [Using Icarus Verilog & GTKWave](#using-icarus-verilog--gtkwave)
- [Key Features](#key-features)
- [License](#license)

---

## Overview

A **D (Data) Flip-Flop** is a fundamental sequential logic circuit element widely used for data storage, pipelining, and synchronization in digital circuit design. 

In this design:
- The flip-flop samples the data input `D` on the **rising edge** (`posedge`) of the clock signal `clk`.
- It includes an **asynchronous active-high reset** (`rst`), meaning the output `Q` is immediately cleared to `0` whenever `rst` goes high, independent of the clock.

---

## Module Specifications

### Port List

| Port | Direction | Type | Description |
| :--- | :---: | :---: | :--- |
| `clk` | Input | `wire` | Clock input signal (triggered on positive edge) |
| `rst` | Input | `wire` | Asynchronous active-high reset signal |
| `D` | Input | `wire` | Data input signal |
| `Q` | Output | `reg` | Registered data output |

### Truth Table

| `rst` | `clk` | `D` | `Q (Next State)` | Operation |
| :---: | :---: | :---: | :---: | :--- |
| `1` | `X` | `X` | `0` | Asynchronous Reset (forced to low) |
| `0` | `↑` (Rising edge) | `0` | `0` | Reset / Clear data |
| `0` | `↑` (Rising edge) | `1` | `1` | Set / Store data |
| `0` | `0` / `1` / `↓` | `X` | `Q_prev` | No change (Hold previous state) |

*Note: `X` represents a "don't care" state.*

---

## Project Structure

```plaintext
d_ff/
├── d_ff.v            # Verilog RTL source code for D Flip-Flop
├── d_fftb.v          # Testbench code for functional verification
├── transcript        # ModelSim console log and output transcript
├── modelsim.ini      # ModelSim project configuration file
├── vsim.wlf          # ModelSim waveform dataset log
└── README.md         # Project documentation
```

---

## RTL Implementation

The module `d_ff` is defined in `d_ff.v`:

```verilog
module d_ff (
    input D,
    input clk,
    input rst,
    output reg Q
);

always @(posedge clk or posedge rst)
begin
    if (rst)
        Q <= 1'b0;
    else
        Q <= D;
end

endmodule
```

---

## Testbench & Verification

The testbench `d_fftb` (`d_fftb.v`) verifies the design under multiple stimulus conditions:
- **Clock Generation:** Generates a symmetrical clock with a 10 time-unit period (5 units low, 5 units high, 50% duty cycle).
- **Asynchronous Reset Verification:** Asserts `rst = 1` initially to verify immediate reset behavior.
- **Data Transfer Verification:** Deasserts `rst = 0` and toggles data input `D` between `0` and `1` across multiple clock cycles.

### Stimulus Sequence

| Time (units) | `rst` | `D` | Expected `Q` | Description |
| :---: | :---: | :---: | :---: | :--- |
| **0** | `1` | `0` | `0` | Reset asserted initially |
| **10** | `0` | `0` | `0` | Reset deasserted, input `D = 0` |
| **20** | `0` | `1` | `0` | `D` transitions to `1`; captured at next clock edge (`t = 25`) |
| **30** | `0` | `0` | `1` | `D` transitions to `0`; captured at next clock edge (`t = 35`) |
| **40** | `0` | `1` | `0` | `D` transitions to `1`; captured at next clock edge (`t = 45`) |
| **50** | `0` | `1` | `1` | `D` stays `1`; maintained across edge (`t = 55`) |
| **60** | `0` | `0` | `1` | `D` transitions to `0`; captured at next clock edge (`t = 65`) |
| **70** | `0` | `0` | `0` | Simulation finished (`$finish`) |

### Simulation Output

Execution transcript generated via ModelSim's `$monitor`:

```plaintext
# Time=0  | D=0 clk=0 rst=1 | Q=0
# Time=5  | D=0 clk=1 rst=1 | Q=0
# Time=10 | D=0 clk=0 rst=0 | Q=0
# Time=15 | D=0 clk=1 rst=0 | Q=0
# Time=20 | D=1 clk=0 rst=0 | Q=0
# Time=25 | D=1 clk=1 rst=0 | Q=1
# Time=30 | D=0 clk=0 rst=0 | Q=1
# Time=35 | D=0 clk=1 rst=0 | Q=0
# Time=40 | D=1 clk=0 rst=0 | Q=0
# Time=45 | D=1 clk=1 rst=0 | Q=1
# Time=50 | D=1 clk=0 rst=0 | Q=1
# Time=55 | D=1 clk=1 rst=0 | Q=1
# Time=60 | D=0 clk=0 rst=0 | Q=1
# Time=65 | D=0 clk=1 rst=0 | Q=0
# ** Note: $finish : d_fftb.v(48)
```

---

## How to Run Simulation

### Using ModelSim / QuestaSim (CLI / GUI)

1. Open **ModelSim** and navigate to the project directory:
   ```tcl
   cd C:/Users/Kaila/Documents/ModelSim_Projects/d_ff
   ```

2. Create the working library (if not already created):
   ```tcl
   vlib work
   ```

3. Compile the design and testbench files:
   ```tcl
   vlog d_ff.v d_fftb.v
   ```

4. Load the simulation:
   ```tcl
   vsim work.d_fftb
   ```

5. Add wave signals to the waveform viewer:
   ```tcl
   add wave *
   ```

6. Run the simulation:
   ```tcl
   run -all
   ```

7. View the full waveform window:
   ```tcl
   wave zoomfull
   ```

---

### Using Icarus Verilog & GTKWave

If you prefer open-source command-line tools:

1. **Compile:**
   ```bash
   iverilog -o d_ff_sim.vvp d_ff.v d_fftb.v
   ```

2. **Simulate:**
   ```bash
   vvp d_ff_sim.vvp
   ```

---

## Key Features

- **Asynchronous Reset Priority:** The sensitivity list `@(posedge clk or posedge rst)` guarantees high-priority asynchronous clearing of state.
- **Glitch-free Output Transitions:** Uses non-blocking assignments (`<=`) inside procedural blocks, adhering to standard sequential logic design practices.
- **Self-contained Verification:** Automated monitoring and simulation finish without requiring manual termination.

---

## License

This project is licensed under the [MIT License](LICENSE) or can be freely used for educational and experimental purposes.

