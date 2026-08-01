class dma_environment;

    //-----------------------------------------
    // Components
    //-----------------------------------------

    dma_generator   gen;
    dma_driver      drv;
    dma_monitor     mon;
    dma_scoreboard  scb;

    //-----------------------------------------
    // Mailboxes
    //-----------------------------------------

    mailbox #(dma_transaction) gen2drv;
    mailbox #(dma_transaction) mon2scb;

    //-----------------------------------------
    // Virtual Interface
    //-----------------------------------------

    virtual axil_if cfg_if;

    //-----------------------------------------
    // Constructor
    //-----------------------------------------

    function new(virtual axil_if cfg_if);

        this.cfg_if = cfg_if;

        // Create Mailboxes
        gen2drv = new();
        mon2scb = new();

        // Create Components
        gen = new(gen2drv);

        drv = new(cfg_if, gen2drv);

        mon = new(cfg_if, mon2scb);

        scb = new(mon2scb);

    endfunction

    //-----------------------------------------
    // Reset Statistics
    //-----------------------------------------

    task reset();

        $display("\n======================================");
        $display("      Environment Reset");
        $display("======================================");

    endtask

    //-----------------------------------------
    // Run Environment
    //-----------------------------------------

    task run();

        reset();

        $display("\n======================================");
        $display(" Starting Verification Environment");
        $display("======================================");

        fork

            gen.run();

            drv.run();

            mon.run();

            scb.run();

        join_any

    endtask

endclass