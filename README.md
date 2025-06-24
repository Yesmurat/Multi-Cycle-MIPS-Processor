# Multi-Cycle MIPS Processor (Verilog)

This repository contains a complete implementation of a **Multi-Cycle MIPS Processor** designed in **Verilog HDL**. It models a basic MIPS processor with separate datapath and controller units, designed for instruction-level waveform simulation and debugging.

---

## 🔧 Features

* Implements core MIPS instructions: `lw`, `sw`, `add`, `sub`, `and`, `or`, `slt`, `addi`, `beq`, `j`
* Fully working FSM-based **main control unit** (`maindec`) and **ALU decoder** (`aludec`)
* **Multi-cycle datapath** architecture: instruction fetch, decode, execution, memory, and write-back stages
* Modules include: `regfile`, `alu`, `mux`, `signext`, `sl2`, `memory`, and `flopenr` registers
* Verified via testbench and waveform analysis using **Icarus Verilog** and **GTKWave**

---

## 📁 Project Structure

```
.
├── alu.v             # ALU operations and zero flag
├── aludec.v          # ALU control decoder
├── controller.v      # Top-level controller module
├── datapath.v        # Core datapath with register file and control logic
├── flopenr.v         # Parameterized D flip-flop with enable and async reset
├── maindec.v         # Main FSM control logic
├── mem.v             # Simple memory with $readmemh preload
├── mux2.v, mux3.v, mux4.v  # Multiplexers
├── regfile.v         # Register file with 2 read ports and 1 write port
├── signext.v, sl2.v  # Sign extension and shift left by 2
├── mips.v            # Top-level processor module
├── top.v             # Memory + MIPS integration
├── testbench.v       # Testbench for simulation
├── memfile.dat       # Preloaded instructions in hex
└── README.md         # You are here :)
```

---

## 🧪 Example Instructions

The processor supports basic memory and arithmetic operations. Below is a sample sequence:

```assembly
# Initialize $t0 = 5
addi $t0, $zero, 5   # 0x20080005

# Store $t0 into memory[0]
sw   $t0, 0($zero)   # 0xac080000

# Load it into $t1
lw   $t1, 0($zero)   # 0x8c090000
```

These instructions can be written in `memfile.dat` as hex:

```
20080005
ac080000
8c090000
```

---

## 🚀 How to Simulate (Icarus Verilog + GTKWave)

```bash
# Compile
iverilog -o mips_tb testbench.v top.v *.v

# Run
vvp mips_tb

# View Waveforms
gtkwave dump.vcd
```

Ensure your testbench generates `dump.vcd` using:

```verilog
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, testbench);
end
```

---

## ✅ Simulation Output

The testbench checks if the memory receives the correct value:

```verilog
if (adr == 0 && writedata == 5)
    $display("Simulation succeeded");
else
    $display("Simulation failed");
```

You can verify each instruction in the waveform viewer (e.g., inspect: `pc`, `instr`, `regdst`, `aluout`, `writedata`, `adr`, `memwrite`, etc.)

---

## 🧠 Learning Outcomes

* FSM design and control signal generation
* Timing analysis and waveform debugging
* Understanding instruction cycle breakdown in real CPUs
* Modular design of processor architecture

---

## 📜 License

This project is open source and free to use under the MIT License.

---

## 🙋‍♂️ Author

Built by Yesmurat. Contributions welcome!
