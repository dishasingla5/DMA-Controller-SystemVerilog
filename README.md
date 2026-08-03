# Configurable Multi-Channel DMA Controller

A SystemVerilog implementation of a configurable **4-channel Direct Memory Access (DMA) Controller** with an **AXI4-Lite configuration interface**, **AXI4 Master memory interface**, and a complete **UVM-based verification environment**.

The project focuses on RTL design, AXI protocol implementation, and verification methodology by developing a modular DMA engine and validating its functionality using UVM components including sequences, driver, monitor, scoreboard, agent, environment, coverage, and assertions.

---

# Features

## RTL Design

- 4 independent DMA channels
- AXI4-Lite Slave interface for CPU configuration
- AXI4 Master interface for memory transactions
- Parameterized address and data widths
- Independent channel FSM control
- Round-Robin arbitration between DMA channels
- Sticky grant mechanism to prevent mid-transfer preemption
- Channel multiplexer for shared AXI Master access
- AXI memory model for simulation
- Modular and reusable RTL architecture

---

## Verification Environment

Implemented a complete **UVM verification environment** consisting of:

- UVM Sequence Item
- UVM Sequence
- UVM Sequencer
- UVM Driver
- UVM Monitor
- UVM Agent
- UVM Environment
- UVM Scoreboard
- UVM Test
- Functional Coverage
- SystemVerilog Assertions

Verification flow:

```
Sequence
    |
    v
Sequencer
    |
    v
Driver
    |
    v
DMA DUT
    |
    v
Monitor
    |
    v
Scoreboard
```

---

# Architecture

```
                         CPU
                          |
                    AXI4-Lite Bus
                          |
              +----------------------+
              |   AXI4-Lite Slave    |
              +----------------------+
                          |
                   Register File
                          |
        +--------------------------------+
        | CH0 | CH1 | CH2 | CH3 | FSMs  |
        +--------------------------------+
                          |
                 Round-Robin Arbiter
                          |
                  Channel Multiplexer
                          |
                     AXI4 Master
                          |
                  AXI Memory Model
```

---

# Repository Structure

```
DMA Controller
│
├── README.md
│
├── docs/
│
├── rtl/
│   ├── arbiter.sv
│   ├── axi4_lite_slave.sv
│   ├── axi4_master.sv
│   ├── axi_if.sv
│   ├── axil_if.sv
│   ├── axi_mem_model.sv
│   ├── ch_fsm.sv
│   ├── channel_mux.sv
│   ├── register_file.sv
│   └── dma_top.sv
│
├── sim/
│
├── tb/
│   └── top_tb.sv
│
└── uvm/
    ├── dma_sequence_item.sv
    ├── dma_sequence.sv
    ├── dma_sequencer.sv
    ├── dma_driver.sv
    ├── dma_monitor.sv
    ├── dma_agent.sv
    ├── dma_scoreboard.sv
    ├── dma_env.sv
    ├── dma_test.sv
    ├── dma_coverage.sv
    └── assertions.sv
```

---

# RTL Modules

| Module | Description |
|---|---|
| `dma_top.sv` | Top-level DMA integration |
| `axi4_lite_slave.sv` | Handles CPU configuration transactions |
| `axi4_master.sv` | Performs AXI memory read/write operations |
| `arbiter.sv` | Round-robin channel arbitration |
| `ch_fsm.sv` | Controls individual DMA channel operation |
| `channel_mux.sv` | Routes selected channel signals |
| `axi_mem_model.sv` | Simulation memory model |
| `axi_if.sv` | AXI4 interface |
| `axil_if.sv` | AXI4-Lite interface |

---

# UVM Components

| Component | Purpose |
|---|---|
| `dma_sequence_item.sv` | Transaction object containing DMA transfer information |
| `dma_sequence.sv` | Generates constrained stimulus |
| `dma_sequencer.sv` | Controls transaction flow to driver |
| `dma_driver.sv` | Drives AXI4-Lite configuration transactions |
| `dma_monitor.sv` | Observes DUT activity |
| `dma_scoreboard.sv` | Checks expected vs actual behavior |
| `dma_agent.sv` | Encapsulates UVM components |
| `dma_env.sv` | Creates complete verification environment |
| `dma_test.sv` | Controls simulation scenarios |
| `dma_coverage.sv` | Functional coverage collection |
| `assertions.sv` | Protocol and design checks |

---

# Verification

The DMA controller is verified using:

- Module-level testing
- AXI4-Lite verification
- AXI4 Master verification
- Multi-channel DMA testing
- UVM-based constrained-random verification
- Scoreboard-based checking
- Functional coverage
- SystemVerilog Assertions

---

# Tools

- SystemVerilog
- UVM 1.2
- Cadence Xcelium
- EDA Playground
- Git
- GitHub

---

# Project Status

Current implementation:

 RTL DMA Controller  
 AXI4-Lite Configuration Interface  
 AXI4 Master Interface  
 Multi-channel Arbitration  
 UVM Verification Environment  
 Functional Coverage  
 Assertions  

Future improvements:

- AXI Burst Transfer Support
- Advanced Coverage Models
- Regression Automation
- Performance Analysis

---

# Learning Outcomes

This project provides hands-on experience with:

- RTL Design using SystemVerilog
- AXI4 and AXI4-Lite Protocols
- DMA Architecture
- FSM Design
- Arbitration Techniques
- UVM Verification Methodology
- Functional Coverage
- Assertion-Based Verification