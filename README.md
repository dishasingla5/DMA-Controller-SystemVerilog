
# Configurable Multi-Channel DMA Controller

A **SystemVerilog-based 4-channel Direct Memory Access (DMA) Controller** featuring an AXI4-Lite configuration interface, an AXI4 Master memory interface, and a UVM-based verification environment.

This project focuses on modular RTL design, AXI protocol implementation, multi-channel arbitration, and functional verification using SystemVerilog and UVM.

## Key Features

### RTL Design
- Four independently controlled DMA channels
- AXI4-Lite slave interface for CPU configuration
- AXI4 master interface for memory transactions
- Parameterized address and data widths
- Independent channel finite-state machines (FSMs)
- Round-robin arbitration between DMA channels
- Sticky-grant mechanism to maintain channel ownership during a transfer
- Channel multiplexer for shared AXI master access
- AXI memory model for simulation

### UVM-Based Verification
- Modular UVM verification environment
- Constrained-random transaction generation
- UVM sequence item, sequence, sequencer, driver, and monitor
- Agent and environment integration
- Scoreboard-based transaction checking
- Functional coverage collection
- SystemVerilog assertions
- Multi-channel DMA stimulus and verification

## Architecture

```text
                    CPU
                     |
               AXI4-Lite Bus
                     |
             +------------------+
             | AXI4-Lite Slave  |
             +------------------+
                     |
               Register File
                     |
          +-----------------------+
          | DMA Channel FSMs      |
          | CH0 | CH1 | CH2 | CH3 |
          +-----------------------+
                     |
             Round-Robin Arbiter
                     |
              Channel Mux
                     |
                AXI4 Master
                     |
              AXI Memory Model
```

The AXI4-Lite interface configures DMA transfers. Independent channel FSMs control channel operation, while the arbiter selects a requesting channel and the multiplexer routes its signals through the shared AXI master interface.

## Repository Structure

```text
DMA-Controller/
├── README.md
├── docs/
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
├── sim/
├── tb/
│   └── top_tb.sv
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

## RTL Modules

| Module | Description |
|---|---|
| `dma_top.sv` | Integrates the DMA controller modules |
| `axi4_lite_slave.sv` | Handles CPU configuration transactions |
| `axi4_master.sv` | Manages AXI memory transactions |
| `arbiter.sv` | Implements round-robin channel arbitration |
| `ch_fsm.sv` | Controls individual DMA channel operation |
| `channel_mux.sv` | Routes the selected channel's signals |
| `register_file.sv` | Stores DMA configuration and control registers |
| `axi_mem_model.sv` | Provides a simulation memory model |
| `axi_if.sv` | Defines the AXI4 interface |
| `axil_if.sv` | Defines the AXI4-Lite interface |
| `dma_top.sv` | Top-level DMA integration |

## UVM Verification Environment

The testbench uses a modular transaction-based architecture.

```text
        UVM Sequence
              |
              v
          Sequencer
              |
              v
           Driver
              |
              v
         DMA Controller
              |
              v
           Monitor
              |
              v
          Scoreboard
              |
              v
       Pass / Fail Results
```

### UVM Components

| Component | Responsibility |
|---|---|
| `dma_sequence_item.sv` | Represents DMA transaction parameters |
| `dma_sequence.sv` | Generates constrained-random stimulus |
| `dma_sequencer.sv` | Coordinates transaction delivery |
| `dma_driver.sv` | Drives configuration transactions |
| `dma_monitor.sv` | Observes DUT activity |
| `dma_scoreboard.sv` | Checks observed behavior against expected results |
| `dma_agent.sv` | Groups the UVM agent components |
| `dma_env.sv` | Instantiates and connects verification components |
| `dma_test.sv` | Configures and runs the test |
| `dma_coverage.sv` | Collects functional coverage |
| `assertions.sv` | Checks implemented protocol and design properties |

## Verification Results

**Latest reported simulation run**

| Metric | Result |
|---|---:|
| Generated transactions | 500 |
| Scoreboard PASS | 128 |
| Scoreboard IGNORED | 372 |
| Scoreboard FAIL | 0 |
| UVM functional coverage | 100% |
| UVM errors | 0 |
| UVM fatal errors | 0 |

The simulation completed without reported UVM errors or fatal errors. The scoreboard classified 128 transactions as PASS, 372 as IGNORED, and none as FAIL.

**Coverage note:** The reported 100% functional coverage applies to the covergroups and bins currently implemented. It does not establish complete verification of the entire DMA controller. Ignored transactions should be reviewed to confirm whether they represent expected non-transfer scenarios.

## Verification Scope

- AXI4-Lite configuration transactions
- DMA channel operation
- Multi-channel arbitration
- Constrained-random stimulus generation
- Scoreboard-based checking
- Functional coverage
- Assertion-based verification

## Tools and Technologies

- **HDL:** SystemVerilog
- **Verification:** UVM 1.2
- **Simulation:** Cadence Xcelium
- **Simulation Platform:** EDA Playground
- **Version Control:** Git and GitHub

## Future Improvements

- AXI4 burst-transfer support
- Expanded coverage for transfer boundaries and arbitration scenarios
- More comprehensive data-integrity and completion checking
- Additional protocol assertions and corner-case testing
- Automated regression testing
- Throughput and latency analysis

## Learning Outcomes

- RTL design using SystemVerilog
- DMA architecture and multi-channel control
- AXI4 and AXI4-Lite protocol concepts
- FSM design and round-robin arbitration
- UVM testbench architecture and constrained-random verification
- Scoreboard-based checking and functional coverage
- Assertion-based verification

---

**Project Focus:** RTL Design | SystemVerilog | AXI Protocols | UVM | Functional Verification | Cadence Xcelium
