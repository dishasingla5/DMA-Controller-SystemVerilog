`timescale 1ns/1ps

//==========================================================
// Class Includes
//==========================================================

`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test.sv"


module top_tb;


    parameter DATA_WIDTH = 32;
    parameter ADDR_WIDTH = 32;
    parameter NUM_CH     = 4;


    //----------------------------------
    // Clock / Reset
    //----------------------------------

    logic clk;
    logic rst_n;



    //----------------------------------
    // Interfaces
    //----------------------------------

    axil_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) cfg_if (

        .clk(clk),
        .rst_n(rst_n)

    );


    axi_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) mem_if();



    //----------------------------------
    // DUT
    //----------------------------------

    dma_top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH),
        .NUM_CH(NUM_CH)

    ) dut (

        .clk(clk),
        .rst_n(rst_n),

        .cfg_if(cfg_if),
        .mem_if(mem_if)

    );



    //----------------------------------
    // Memory Model
    //----------------------------------

    axi_mem_model u_mem (

        .clk(clk),
        .rst_n(rst_n),

        .mem_if(mem_if)

    );



    //----------------------------------
    // Verification Test
    //----------------------------------

    dma_test test;



    //----------------------------------
    // Clock Generation
    //----------------------------------

    initial begin

        clk = 1'b0;

        forever #5 clk = ~clk;

    end



    //----------------------------------
    // Reset Generation
    //----------------------------------

    initial begin

        rst_n = 1'b0;


        // AXI-Lite defaults

        cfg_if.awaddr  = '0;
        cfg_if.awvalid = 1'b0;

        cfg_if.wdata   = '0;
        cfg_if.wvalid  = 1'b0;

        cfg_if.bready  = 1'b1;


        cfg_if.araddr  = '0;
        cfg_if.arvalid = 1'b0;

        cfg_if.rready  = 1'b1;



        repeat(5) @(posedge clk);


        rst_n = 1'b1;


    end



    //----------------------------------
    // Start Verification Environment
    //----------------------------------

    initial begin


        wait(rst_n);


        repeat(2) @(posedge clk);



        test = new(cfg_if);


        test.run();



    end



    //----------------------------------
    // One-Hot Grant Assertion
    //----------------------------------

    always @(posedge clk) begin


        if($countones(dut.ch_grant) > 1) begin


            $display("--------------------------------");
            $display("ERROR : Multiple DMA Grants");
            $display("--------------------------------");


            $finish;


        end


    end



    //----------------------------------
    // Timeout Watchdog
    //----------------------------------

    initial begin


        wait(rst_n);



        repeat(5000) @(posedge clk);



        $display("");
        $display("--------------------------------");
        $display("SIMULATION TIMEOUT");
        $display("--------------------------------");

        $display("REQ   = %b", dut.ch_req);
        $display("GRANT = %b", dut.ch_grant);
        $display("BUSY  = %b", dut.busy);
        $display("DONE  = %b", dut.done);

        $display("--------------------------------");


        $finish;


    end



    //----------------------------------
    // Wave Dump
    //----------------------------------

    initial begin


        $dumpfile("dma_top.vcd");

        $dumpvars(0,top_tb);


    end



endmodule