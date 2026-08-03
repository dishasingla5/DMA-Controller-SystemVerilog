`ifndef DMA_ENV_SV
`define DMA_ENV_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class dma_env extends uvm_env;

    `uvm_component_utils(dma_env)

    //-----------------------------------------
    // Components
    //-----------------------------------------

    dma_agent       agent;
    dma_scoreboard  scb;
    dma_coverage    cov;

    //-----------------------------------------
    // Constructor
    //-----------------------------------------

    function new(string name = "dma_env",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction

    //-----------------------------------------
    // Build Phase
    //-----------------------------------------

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        agent = dma_agent::type_id::create("agent", this);
        scb   = dma_scoreboard::type_id::create("scb", this);
        cov   = dma_coverage::type_id::create("cov", this);

    endfunction

    //-----------------------------------------
    // Connect Phase
    //-----------------------------------------

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        //-------------------------------------
        // Driver <-> Sequencer
        //-------------------------------------

        agent.driver.seq_item_port.connect(
            agent.sequencer.seq_item_export
        );

        //-------------------------------------
        // Monitor -> Scoreboard
        //-------------------------------------

        agent.monitor.ap.connect(
            scb.analysis_export
        );

        //-------------------------------------
        // Monitor -> Coverage
        //-------------------------------------

        agent.monitor.ap.connect(
            cov.analysis_export
        );

    endfunction

endclass

`endif