# Configurable Multi-Channel DMA Controller

A SystemVerilog implementation of a configurable **4-channel Direct Memory Access (DMA) Controller** featuring an **AXI4-Lite configuration interface** and an **AXI4 Master interface** for memory transactions.

The project is being developed to explore RTL design, digital system architecture, and verification methodologies through a modular implementation of a DMA engine. Each module is designed, tested, and verified independently before system-level integration.

---

## Features

- Configurable 4-channel DMA architecture
- AXI4-Lite Slave interface for software configuration
- AXI4 Master interface for memory read/write transactions
- Parameterized address and data widths
- Independent Finite State Machine (FSM) for each DMA channel
- Round-Robin Arbiter for fair channel scheduling
- Channel Multiplexer for shared AXI Master access
- AXI Memory Model for simulation
- Modular and reusable RTL design
- SystemVerilog-based verification environment

---

## Architecture

```
                   CPU
                    │
              AXI4-Lite Bus
                    │
          +---------------------+
          |  AXI4-Lite Slave    |
          +---------------------+
                    │
             Register Interface
                    │
     +---------------------------------+
     | CH0 | CH1 | CH2 | CH3 |  FSMs   |
     +---------------------------------+
                    │
          Round-Robin Arbiter
                    │
             Channel Multiplexer
                    │
               AXI4 Master
                    │
             AXI Memory Model
```

---

## Repository Structure

```
DMAController
│
├── docs/                 # Project documentation
├── rtl/                  # RTL source files
│   ├── arbiter.sv
│   ├── axi4_lite_slave.sv
│   ├── axi4_master.sv
│   ├── axi_if.sv
│   ├── axi_mem_model.sv
│   ├── axil_if.sv
│   ├── ch_fsm.sv
│   ├── channel_mux.sv
│   ├── design.sv
│   └── dma_top.sv
│
├── sim/                  # Simulation files
├── tb/                   # Testbenches
└── README.md
```

---

## RTL Modules

| Module | Description |
|---------|-------------|
| `dma_top.sv` | Top-level integration of the DMA controller |
| `axi4_lite_slave.sv` | Receives DMA configuration from the CPU |
| `axi4_master.sv` | Executes memory read/write transactions |
| `arbiter.sv` | Performs round-robin arbitration between channels |
| `ch_fsm.sv` | Controls the operation of each DMA channel |
| `channel_mux.sv` | Routes the selected channel to the AXI Master |
| `axi_mem_model.sv` | Memory model used for simulation |
| `axi_if.sv` | AXI4 interface definition |
| `axil_if.sv` | AXI4-Lite interface definition |

---

## Verification

The project includes dedicated testbenches for validating individual modules as well as the complete DMA controller.

Current verification includes:

- Register interface verification
- Arbiter verification
- AXI4-Lite interface verification
- AXI Master verification
- Multi-channel DMA operation
- Top-level integration testing

---

## Tools

- SystemVerilog
- Cadence Xcelium
- EDA Playground
- Git
- GitHub

---

## Project Status

This project is currently under active development.

Planned enhancements include:

- Functional Coverage
- SystemVerilog Assertions (SVA)
- UVM-based Verification Environment
- Randomized Regression Testing
- AXI Burst Transfer Support
- Performance Optimization

---

## Learning Outcomes

Through this project, I am gaining practical experience in:

- RTL Design using SystemVerilog
- AXI4 / AXI4-Lite Protocol Implementation
- DMA Controller Architecture
- Arbitration Techniques
- FSM Design
- Digital Design Verification
- Modular Hardware Design