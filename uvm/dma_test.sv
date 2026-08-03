`ifndef DMA_TEST_SV
`define DMA_TEST_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class dma_test extends uvm_test;

    `uvm_component_utils(dma_test)

    //-----------------------------------------
    // Environment
    //-----------------------------------------

    dma_env env;

    //-----------------------------------------
    // Constructor
    //-----------------------------------------

    function new(string name = "dma_test",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction

    //-----------------------------------------
    // Build Phase
    //-----------------------------------------

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        env = dma_env::type_id::create("env", this);

    endfunction

    //-----------------------------------------
    // Run Phase
    //-----------------------------------------

    task run_phase(uvm_phase phase);

        dma_sequence seq;

        phase.raise_objection(this);

        `uvm_info("TEST",
                  "Starting DMA Test",
                  UVM_LOW)

        seq = dma_sequence::type_id::create("seq");

        seq.start(env.agent.sequencer);

        #50ns;

        `uvm_info("TEST",
                  "DMA Test Completed",
                  UVM_LOW)

        phase.drop_objection(this);

    endtask

endclass

`endif