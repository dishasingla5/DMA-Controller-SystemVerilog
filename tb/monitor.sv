class dma_monitor;

    //-----------------------------------------
    // Virtual Interface
    //-----------------------------------------

    virtual axil_if cfg_if;

    //-----------------------------------------
    // Mailbox
    //-----------------------------------------

    mailbox #(dma_transaction) mon2scb;

    //-----------------------------------------
    // Transaction
    //-----------------------------------------

    dma_transaction tr;

    //-----------------------------------------
    // Constructor
    //-----------------------------------------

    function new(
        virtual axil_if cfg_if,
        mailbox #(dma_transaction) mon2scb
    );

        this.cfg_if  = cfg_if;
        this.mon2scb = mon2scb;

    endfunction

    //-----------------------------------------
    // Run
    //-----------------------------------------

    task run();

        tr = new();

        forever begin

            // Wait for a valid AXI-Lite write
            wait(cfg_if.awvalid && cfg_if.wvalid);

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

                    $display("\n[MONITOR] Transaction Observed");
                    tr.display();

                    mon2scb.put(tr.copy());

                    tr = new();

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

                    $display("\n[MONITOR] Transaction Observed");
                    tr.display();

                    mon2scb.put(tr.copy());

                    tr = new();

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

                    $display("\n[MONITOR] Transaction Observed");
                    tr.display();

                    mon2scb.put(tr.copy());

                    tr = new();

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

                    $display("\n[MONITOR] Transaction Observed");
                    tr.display();

                    mon2scb.put(tr.copy());

                    tr = new();

                end

            endcase

            // Wait for write handshake to finish
            wait(!(cfg_if.awvalid && cfg_if.wvalid));

        end

    endtask

endclass