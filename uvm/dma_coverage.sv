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


        option.per_instance = 1;


        //-------------------------------------
        // Channel Coverage
        //-------------------------------------

        cp_channel : coverpoint tr.channel {

            bins ch0 = {0};
            bins ch1 = {1};
            bins ch2 = {2};
            bins ch3 = {3};

        }


        //-------------------------------------
        // Transfer Length Coverage
        //-------------------------------------

        cp_length : coverpoint tr.length {

            bins len_small  = {[1:2]};
            bins len_medium = {[3:5]};
            bins len_large  = {[6:8]};

        }



        //-------------------------------------
        // Enable Coverage
        //-------------------------------------

        cp_enable : coverpoint tr.enable {

            bins disabled = {0};
            bins enabled  = {1};

        }



        //-------------------------------------
        // Start Coverage
        //-------------------------------------

        cp_start : coverpoint tr.start {

            bins not_started = {0};
            bins started     = {1};

        }



        //-------------------------------------
        // Channel x Length Coverage
        //-------------------------------------

        channel_length_cross :

        cross cp_channel, cp_length;



        //-------------------------------------
        // Channel x Enable Coverage
        //-------------------------------------

        channel_enable_cross :

        cross cp_channel, cp_enable;


        //-------------------------------------
        // Enable x Start Coverage
        //-------------------------------------

        enable_start_cross :

        cross cp_enable, cp_start;


    endgroup

    //-----------------------------------------
    // Constructor
    //-----------------------------------------

    function new(string name = "dma_coverage",
                 uvm_component parent = null);

        super.new(name,parent);

        dma_cg = new();

    endfunction

    //-----------------------------------------
    // Analysis Callback
    //-----------------------------------------

    virtual function void write(dma_sequence_item t);


        tr = dma_sequence_item::type_id::create("tr");


        tr.copy(t);


        dma_cg.sample();

        `uvm_info("COVERAGE",
        $sformatf("CH=%0d LEN=%0d EN=%0d START=%0d",
                  tr.channel,
                  tr.length,
                  tr.enable,
                  tr.start),
        UVM_LOW)

    endfunction

    //-----------------------------------------
    // Coverage Report
    //-----------------------------------------

    function void report_phase(uvm_phase phase);

        super.report_phase(phase);


        `uvm_info("COVERAGE_REPORT",
        $sformatf("\n\
====================================\n\
DMA FUNCTIONAL COVERAGE\n\
====================================\n\
Coverage : %0.2f%%\n\
====================================",
        dma_cg.get_coverage()),
        UVM_NONE)


    endfunction


endclass


`endif