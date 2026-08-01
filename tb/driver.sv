class dma_driver;

    //-----------------------------------------
    // Virtual Interface
    //-----------------------------------------

    virtual axil_if cfg_if;

    //-----------------------------------------
    // Clock
    //-----------------------------------------

 //   virtual logic clk;

    //-----------------------------------------
    // Mailbox
    //-----------------------------------------

    mailbox #(dma_transaction) gen2drv;

    //-----------------------------------------
    // Transaction
    //-----------------------------------------

    dma_transaction tr;

    //-----------------------------------------
    // Constructor
    //-----------------------------------------

    function new(
        virtual axil_if cfg_if,
        mailbox #(dma_transaction) gen2drv
    );

        this.cfg_if  = cfg_if;
        this.gen2drv = gen2drv;

    endfunction

    //-----------------------------------------
    // AXI-Lite Write
    //-----------------------------------------

    task axil_write(input [31:0] addr,
                input [31:0] data);

      @(posedge cfg_if.clk);

      cfg_if.awaddr  <= addr;
      cfg_if.awvalid <= 1;
      cfg_if.wdata   <= data;
      cfg_if.wvalid  <= 1;

      wait(cfg_if.awready && cfg_if.wready);

      @(posedge cfg_if.clk);

      cfg_if.awvalid <= 0;
      cfg_if.wvalid  <= 0;

      cfg_if.bready <= 1;

      wait(cfg_if.bvalid);

      @(posedge cfg_if.clk);

      cfg_if.bready <= 0;

	endtask
  

    //-----------------------------------------
    // Drive One DMA Transaction
    //-----------------------------------------

    task drive_transaction(dma_transaction tr);

        case(tr.channel)

            0: begin

                axil_write(32'h00,tr.src_addr);
                axil_write(32'h04,tr.dst_addr);
                axil_write(32'h08,tr.length);
                axil_write(32'h0C,32'h3);

            end

            1: begin

                axil_write(32'h10,tr.src_addr);
                axil_write(32'h14,tr.dst_addr);
                axil_write(32'h18,tr.length);
                axil_write(32'h1C,32'h3);

            end

            2: begin

                axil_write(32'h20,tr.src_addr);
                axil_write(32'h24,tr.dst_addr);
                axil_write(32'h28,tr.length);
                axil_write(32'h2C,32'h3);

            end

            3: begin

                axil_write(32'h30,tr.src_addr);
                axil_write(32'h34,tr.dst_addr);
                axil_write(32'h38,tr.length);
                axil_write(32'h3C,32'h3);

            end

        endcase

    endtask

    //-----------------------------------------
    // Run
    //-----------------------------------------

    task run();

        forever begin

            gen2drv.get(tr);

            $display("\n[DRIVER] Driving Transaction");

            tr.display();

            drive_transaction(tr);

        end

    endtask

endclass