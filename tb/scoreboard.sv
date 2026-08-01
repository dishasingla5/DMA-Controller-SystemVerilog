class dma_scoreboard;

    //-----------------------------------------
    // Mailbox
    //-----------------------------------------

    mailbox #(dma_transaction) mon2scb;

    //-----------------------------------------
    // Transaction
    //-----------------------------------------

    dma_transaction tr;

    //-----------------------------------------
    // Statistics
    //-----------------------------------------

    int total;
    int pass;
    int fail;

    // Number of transactions expected
    int expected_transactions = 10;

    //-----------------------------------------
    // Constructor
    //-----------------------------------------

    function new(mailbox #(dma_transaction) mon2scb);

        this.mon2scb = mon2scb;

        total = 0;
        pass  = 0;
        fail  = 0;

    endfunction

    //-----------------------------------------
    // Check Transaction
    //-----------------------------------------

    task check_transaction(dma_transaction tr);

        total++;

        //-------------------------------
        // Channel Check
        //-------------------------------

        if(tr.channel > 3) begin
            $display("[SCB] FAIL : Invalid Channel");
            fail++;
            return;
        end

        //-------------------------------
        // Source Address Check
        //-------------------------------

        if(!(tr.src_addr inside {
                32'h000,
                32'h020,
                32'h040,
                32'h060
            })) begin

            $display("[SCB] FAIL : Invalid Source Address");
            fail++;
            return;
        end

        //-------------------------------
        // Destination Address Check
        //-------------------------------

        if(!(tr.dst_addr inside {
                32'h100,
                32'h120,
                32'h140,
                32'h160
            })) begin

            $display("[SCB] FAIL : Invalid Destination Address");
            fail++;
            return;
        end

        //-------------------------------
        // Length Check
        //-------------------------------

        if(tr.length == 0) begin
            $display("[SCB] FAIL : Length = 0");
            fail++;
            return;
        end

        //-------------------------------
        // Enable Check
        //-------------------------------

        if(!tr.enable) begin
            $display("[SCB] FAIL : DMA Disabled");
            fail++;
            return;
        end

        //-------------------------------
        // Start Check
        //-------------------------------

        if(!tr.start) begin
            $display("[SCB] FAIL : Start Bit Missing");
            fail++;
            return;
        end

        //-------------------------------
        // PASS
        //-------------------------------

        pass++;

        $display("[SCB] PASS : Transaction Accepted");

    endtask

    //-----------------------------------------
    // Run
    //-----------------------------------------

    task run();

        repeat(expected_transactions) begin

            mon2scb.get(tr);

            check_transaction(tr);

            $display("--------------------------------------");
            $display("Transactions : %0d", total);
            $display("PASS         : %0d", pass);
            $display("FAIL         : %0d", fail);
            $display("--------------------------------------");

        end

        //--------------------------------------
        // Final Report
        //--------------------------------------

        $display("");
        $display("========================================");
        $display("        DMA SCOREBOARD REPORT");
        $display("========================================");
        $display("Expected Transactions : %0d", expected_transactions);
        $display("Received Transactions : %0d", total);
        $display("PASS                  : %0d", pass);
        $display("FAIL                  : %0d", fail);

        if(fail == 0 && pass == expected_transactions)
            $display("STATUS : ALL TESTS PASSED");
        else
            $display("STATUS : TEST FAILED");

        $display("========================================");

    endtask

endclass