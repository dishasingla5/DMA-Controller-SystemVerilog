`timescale 1ns/1ps

//------------------------------------------------------------
// UVM
//------------------------------------------------------------
`include "uvm_macros.svh"
import uvm_pkg::*;

//------------------------------------------------------------
// UVM Includes
//------------------------------------------------------------

`include "dma_sequence.sv"
`include "dma_sequencer.sv"
`include "dma_sequence_item.sv"
`include "dma_monitor.sv"
`include "dma_driver.sv"
`include "dma_agent.sv"
`include "dma_scoreboard.sv"
`include "dma_env.sv"
`include "dma_coverage.sv"
`include "dma_test.sv"
`include "assertions.sv"

module top_tb;

    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 32;
    parameter NUM_CH     = 4;

    //--------------------------------------------------------
    // Clock / Reset
    //--------------------------------------------------------

    logic clk;
    logic rst_n;

    //--------------------------------------------------------
    // Interfaces
    //--------------------------------------------------------

    axil_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) cfg_if(
        .clk(clk),
        .rst_n(rst_n)
    );

    axi_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) mem_if();

    //--------------------------------------------------------
    // DUT
    //--------------------------------------------------------

    dma_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .NUM_CH(NUM_CH)
    ) dut(
        .clk(clk),
        .rst_n(rst_n),
        .cfg_if(cfg_if),
        .mem_if(mem_if)
    );

    //--------------------------------------------------------
    // Memory Model
    //--------------------------------------------------------

    axi_mem_model u_mem(
        .clk(clk),
        .rst_n(rst_n),
        .mem_if(mem_if)
    );

    //--------------------------------------------------------
    // Clock
    //--------------------------------------------------------

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //--------------------------------------------------------
    // Reset
    //--------------------------------------------------------

    initial begin

        rst_n = 0;

        cfg_if.awaddr  = '0;
        cfg_if.awvalid = 0;
        cfg_if.wdata   = '0;
        cfg_if.wvalid  = 0;
        cfg_if.bready  = 1;

        cfg_if.araddr  = '0;
        cfg_if.arvalid = 0;
        cfg_if.rready  = 1;

        repeat(5) @(posedge clk);

        rst_n = 1;

    end

    //--------------------------------------------------------
    // UVM Configuration
    //--------------------------------------------------------

    initial begin

        uvm_config_db#(virtual axil_if)::set(
            null,
            "*",
            "cfg_if",
            cfg_if
        );

        run_test("dma_test");

    end

    //--------------------------------------------------------
    // One Hot Checker
    //--------------------------------------------------------

    always @(posedge clk) begin

        if($countones(dut.ch_grant) > 1) begin

            $error("Multiple DMA Grants");

        end

    end

    //--------------------------------------------------------
    // Watchdog
    //--------------------------------------------------------

    initial begin

        wait(rst_n);

        repeat(5000) @(posedge clk);

        `uvm_fatal("TIMEOUT","Simulation Timeout")

    end

    //--------------------------------------------------------
    // Waveform
    //--------------------------------------------------------

    initial begin

        $dumpfile("dma_top.vcd");
        $dumpvars(0,top_tb);

    end

endmodule