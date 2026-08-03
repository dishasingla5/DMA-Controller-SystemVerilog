`ifndef DMA_AGENT_SV
`define DMA_AGENT_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class dma_agent extends uvm_agent;

    `uvm_component_utils(dma_agent)

    //------------------------------------------
    // Components
    //------------------------------------------

    dma_sequencer sequencer;
    dma_driver    driver;
    dma_monitor   monitor;

    //------------------------------------------
    // Constructor
    //------------------------------------------

    function new(string name = "dma_agent",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction

    //------------------------------------------
    // Build Phase
    //------------------------------------------

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        sequencer = dma_sequencer::type_id::create("sequencer", this);
        driver    = dma_driver   ::type_id::create("driver", this);
        monitor   = dma_monitor  ::type_id::create("monitor", this);

    endfunction

    //------------------------------------------
    // Connect Phase
    //------------------------------------------

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        driver.seq_item_port.connect(
            sequencer.seq_item_export
        );

    endfunction

endclass

`endif