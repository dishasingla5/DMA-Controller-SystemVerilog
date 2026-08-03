`ifndef DMA_SCOREBOARD_SV
`define DMA_SCOREBOARD_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class dma_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(dma_scoreboard)

    //-----------------------------------------
    // Analysis Implementation Port
    //-----------------------------------------

    uvm_analysis_imp #(dma_sequence_item, dma_scoreboard) analysis_export;

    //-----------------------------------------
    // Statistics
    //-----------------------------------------

    int total;
    int pass;
    int fail;

    //-----------------------------------------
    // Constructor
    //-----------------------------------------

    function new(string name = "dma_scoreboard",
                 uvm_component parent = null);

        super.new(name, parent);

        analysis_export = new("analysis_export", this);

        total = 0;
        pass  = 0;
        fail  = 0;

    endfunction

    //-----------------------------------------
    // Receive Transaction
    //-----------------------------------------

    virtual function void write(dma_sequence_item tr);

        total++;

        //-------------------------------------
        // Channel Check
        //-------------------------------------

        if(tr.channel > 3) begin

            `uvm_error("SCB","Invalid Channel")
            fail++;
            return;

        end

        //-------------------------------------
        // Source Address Check
        //-------------------------------------

        if(!(tr.src_addr inside {
                32'h000,
                32'h020,
                32'h040,
                32'h060
            })) begin

            `uvm_error("SCB","Invalid Source Address")
            fail++;
            return;

        end

        //-------------------------------------
        // Destination Address Check
        //-------------------------------------

        if(!(tr.dst_addr inside {
                32'h100,
                32'h120,
                32'h140,
                32'h160
            })) begin

            `uvm_error("SCB","Invalid Destination Address")
            fail++;
            return;

        end

        //-------------------------------------
        // Length Check
        //-------------------------------------

        if(tr.length == 0) begin

            `uvm_error("SCB","Length = 0")
            fail++;
            return;

        end

        //-------------------------------------
        // Enable Check
        //-------------------------------------

        if(!tr.enable) begin

            `uvm_error("SCB","DMA Disabled")
            fail++;
            return;

        end

        //-------------------------------------
        // Start Check
        //-------------------------------------

        if(!tr.start) begin

            `uvm_error("SCB","Start Bit Missing")
            fail++;
            return;

        end

        //-------------------------------------
        // PASS
        //-------------------------------------

        pass++;

        `uvm_info("SCB",
                  "Transaction Accepted",
                  UVM_LOW)

    endfunction

    //-----------------------------------------
    // Report
    //-----------------------------------------

    function void report_phase(uvm_phase phase);

        super.report_phase(phase);

        `uvm_info("SCB",
        $sformatf("\n\
========================================\n\
DMA SCOREBOARD REPORT\n\
========================================\n\
Received Transactions : %0d\n\
PASS                  : %0d\n\
FAIL                  : %0d\n\
========================================",
        total,
        pass,
        fail),
        UVM_NONE)

    endfunction

endclass

`endif