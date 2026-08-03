`ifndef DMA_MONITOR_SV
`define DMA_MONITOR_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class dma_monitor extends uvm_monitor;

    `uvm_component_utils(dma_monitor)

    //-----------------------------------------
    // Virtual Interface
    //-----------------------------------------

    virtual axil_if cfg_if;

    //-----------------------------------------
    // Analysis Port
    //-----------------------------------------

    uvm_analysis_port #(dma_sequence_item) ap;

    //-----------------------------------------
    // Constructor
    //-----------------------------------------

    function new(string name="dma_monitor",
                 uvm_component parent=null);

        super.new(name,parent);
        ap = new("ap", this);

    endfunction

    //-----------------------------------------
    // Build Phase
    //-----------------------------------------

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db#(virtual axil_if)::get(this,
                                                 "",
                                                 "cfg_if",
                                                 cfg_if))
            `uvm_fatal("MONITOR","Virtual Interface Not Found");

    endfunction

    //-----------------------------------------
    // Run Phase
    //-----------------------------------------

    task run_phase(uvm_phase phase);

        dma_sequence_item tr;

        bit handshake;
        bit prev_handshake;

        tr = dma_sequence_item::type_id::create("tr");
        prev_handshake = 0;

        forever begin

            @(posedge cfg_if.clk);

            //---------------------------------
            // AXI-Lite Write Handshake
            //---------------------------------

            handshake =
                cfg_if.awvalid &&
                cfg_if.awready &&
                cfg_if.wvalid  &&
                cfg_if.wready;

            //---------------------------------
            // Capture ONLY once per write
            //---------------------------------

            if(handshake && !prev_handshake) begin

                case(cfg_if.awaddr)

                    //---------------------------------
                    // Channel 0
                    //---------------------------------

                    32'h00: begin
                        tr.channel  = 0;
                        tr.src_addr = cfg_if.wdata;
                    end

                    32'h04: begin
                        tr.dst_addr = cfg_if.wdata;
                    end

                    32'h08: begin
                        tr.length = cfg_if.wdata;
                    end

                    32'h0C: begin

                        tr.enable = cfg_if.wdata[0];
                        tr.start  = cfg_if.wdata[1];

                        ap.write(tr);

                        `uvm_info("MONITOR",
                                  "Channel-0 Transaction",
                                  UVM_LOW)

                        tr.print();

                        tr = dma_sequence_item::type_id::create("tr");

                    end

                    //---------------------------------
                    // Channel 1
                    //---------------------------------

                    32'h10: begin
                        tr.channel  = 1;
                        tr.src_addr = cfg_if.wdata;
                    end

                    32'h14: begin
                        tr.dst_addr = cfg_if.wdata;
                    end

                    32'h18: begin
                        tr.length = cfg_if.wdata;
                    end

                    32'h1C: begin

                        tr.enable = cfg_if.wdata[0];
                        tr.start  = cfg_if.wdata[1];

                        ap.write(tr);

                        `uvm_info("MONITOR",
                                  "Channel-1 Transaction",
                                  UVM_LOW)

                        tr.print();

                        tr = dma_sequence_item::type_id::create("tr");

                    end

                    //---------------------------------
                    // Channel 2
                    //---------------------------------

                    32'h20: begin
                        tr.channel  = 2;
                        tr.src_addr = cfg_if.wdata;
                    end

                    32'h24: begin
                        tr.dst_addr = cfg_if.wdata;
                    end

                    32'h28: begin
                        tr.length = cfg_if.wdata;
                    end

                    32'h2C: begin

                        tr.enable = cfg_if.wdata[0];
                        tr.start  = cfg_if.wdata[1];

                        ap.write(tr);

                        `uvm_info("MONITOR",
                                  "Channel-2 Transaction",
                                  UVM_LOW)

                        tr.print();

                        tr = dma_sequence_item::type_id::create("tr");

                    end

                    //---------------------------------
                    // Channel 3
                    //---------------------------------

                    32'h30: begin
                        tr.channel  = 3;
                        tr.src_addr = cfg_if.wdata;
                    end

                    32'h34: begin
                        tr.dst_addr = cfg_if.wdata;
                    end

                    32'h38: begin
                        tr.length = cfg_if.wdata;
                    end

                    32'h3C: begin

                        tr.enable = cfg_if.wdata[0];
                        tr.start  = cfg_if.wdata[1];

                        ap.write(tr);

                        `uvm_info("MONITOR",
                                  "Channel-3 Transaction",
                                  UVM_LOW)

                        tr.print();

                        tr = dma_sequence_item::type_id::create("tr");

                    end

                endcase

            end

            //---------------------------------
            // Save Previous Handshake
            //---------------------------------

            prev_handshake = handshake;

        end

    endtask

endclass

`endif