`ifndef DMA_DRIVER_SV
`define DMA_DRIVER_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class dma_driver extends uvm_driver #(dma_sequence_item);

    `uvm_component_utils(dma_driver)

    //-----------------------------------------
    // Virtual Interface
    //-----------------------------------------

    virtual axil_if cfg_if;

    //-----------------------------------------
    // Constructor
    //-----------------------------------------

    function new(string name = "dma_driver",
                 uvm_component parent = null);

        super.new(name, parent);

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
        begin
            `uvm_fatal("DRIVER",
                       "Virtual Interface Not Found")
        end

    endfunction

    //-----------------------------------------
    // AXI-Lite Write
    //-----------------------------------------

    task axil_write(input [31:0] addr,
                    input [31:0] data);

        @(posedge cfg_if.clk);

        cfg_if.awaddr  <= addr;
        cfg_if.awvalid <= 1'b1;

        cfg_if.wdata   <= data;
        cfg_if.wvalid  <= 1'b1;

        wait(cfg_if.awready && cfg_if.wready);

        @(posedge cfg_if.clk);

        cfg_if.awvalid <= 1'b0;
        cfg_if.wvalid  <= 1'b0;

        cfg_if.bready  <= 1'b1;

        wait(cfg_if.bvalid);

        @(posedge cfg_if.clk);

        cfg_if.bready <= 1'b0;

    endtask

    //-----------------------------------------
    // Drive Transaction
    //-----------------------------------------

    task drive_transaction(dma_sequence_item tr);

        case(tr.channel)

            2'd0: begin
                axil_write(32'h00, tr.src_addr);
                axil_write(32'h04, tr.dst_addr);
                axil_write(32'h08, tr.length);
                axil_write(32'h0C, 32'h3);
            end

            2'd1: begin
                axil_write(32'h10, tr.src_addr);
                axil_write(32'h14, tr.dst_addr);
                axil_write(32'h18, tr.length);
                axil_write(32'h1C, 32'h3);
            end

            2'd2: begin
                axil_write(32'h20, tr.src_addr);
                axil_write(32'h24, tr.dst_addr);
                axil_write(32'h28, tr.length);
                axil_write(32'h2C, 32'h3);
            end

            2'd3: begin
                axil_write(32'h30, tr.src_addr);
                axil_write(32'h34, tr.dst_addr);
                axil_write(32'h38, tr.length);
                axil_write(32'h3C, 32'h3);
            end

        endcase

    endtask

    //-----------------------------------------
    // Run Phase
    //-----------------------------------------

    task run_phase(uvm_phase phase);

        dma_sequence_item tr;

        forever begin

            seq_item_port.get_next_item(tr);

            `uvm_info("DRIVER",
                      "Driving DMA Transaction",
                      UVM_LOW)

            tr.print();

            drive_transaction(tr);

            seq_item_port.item_done();

        end

    endtask

endclass

`endif