`ifndef DMA_SEQUENCE_SV
`define DMA_SEQUENCE_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class dma_sequence extends uvm_sequence #(dma_sequence_item);

    `uvm_object_utils(dma_sequence)

    //-----------------------------------------
    // Number of Transactions
    //-----------------------------------------

    int num_transactions = 10;

    //-----------------------------------------
    // Constructor
    //-----------------------------------------

    function new(string name = "dma_sequence");

        super.new(name);

    endfunction

    //-----------------------------------------
    // Main Sequence
    //-----------------------------------------

    virtual task body();

        dma_sequence_item req;

        repeat(num_transactions) begin

            req = dma_sequence_item::type_id::create("req");

            start_item(req);

            if(!req.randomize()) begin

                `uvm_fatal("SEQ", "Randomization Failed")

            end

            finish_item(req);

            `uvm_info("SEQUENCE",
                      $sformatf("Generated Transaction"),
                      UVM_LOW)

            req.print();

        end

        `uvm_info("SEQUENCE",
                  $sformatf("Generated %0d Transactions",
                            num_transactions),
                  UVM_LOW)

    endtask

endclass

`endif