`ifndef DMA_SEQUENCER_SV
`define DMA_SEQUENCER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class dma_sequencer extends uvm_sequencer #(dma_sequence_item);

    `uvm_component_utils(dma_sequencer)

    //------------------------------------------
    // Constructor
    //------------------------------------------

    function new(string name = "dma_sequencer",
                 uvm_component parent = null);

        super.new(name, parent);

    endfunction

endclass

`endif