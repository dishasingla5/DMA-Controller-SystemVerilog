`ifndef DMA_COVERAGE_SV
`define DMA_COVERAGE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class dma_coverage extends uvm_subscriber #(dma_sequence_item);

    `uvm_component_utils(dma_coverage)

    //-----------------------------------------
    // Transaction
    //-----------------------------------------

    dma_sequence_item tr;

    //-----------------------------------------
    // Covergroup
    //-----------------------------------------

    covergroup dma_cg;

        cp_channel : coverpoint tr.channel {

            bins ch0 = {0};
            bins ch1 = {1};
            bins ch2 = {2};
            bins ch3 = {3};

        }

        cp_length : coverpoint tr.length {

            bins len_small  = {[1:2]};
            bins len_medium = {[3:5]};
            bins len_large  = {[6:8]};

        }

        cp_enable : coverpoint tr.enable {

            bins disabled = {0};
            bins enabled  = {1};

        }

        cross cp_channel, cp_length;

    endgroup

    //-----------------------------------------
    // Constructor
    //-----------------------------------------

    function new(string name = "dma_coverage",
                 uvm_component parent = null);

        super.new(name, parent);

        dma_cg = new();

    endfunction

    //-----------------------------------------
    // Analysis Port Callback
    //-----------------------------------------

    virtual function void write(dma_sequence_item t);

        tr = t;

        dma_cg.sample();

        `uvm_info("COVERAGE",
                  $sformatf("CH=%0d LEN=%0d EN=%0d",
                            tr.channel,
                            tr.length,
                            tr.enable),
                  UVM_LOW)

    endfunction

    //-----------------------------------------
    // Report Phase
    //-----------------------------------------

    function void report_phase(uvm_phase phase);

        super.report_phase(phase);

        `uvm_info("COVERAGE",
                  $sformatf("Functional Coverage = %0.2f%%",
                            dma_cg.get_coverage()),
                  UVM_NONE)

    endfunction

endclass

`endif