class dma_generator;

    //-----------------------------------------
    // Mailbox to Driver
    //-----------------------------------------
  mailbox #(dma_trAaAAAAAansaction) gen2drv;

    //-----------------------------------------
    // Transaction Handle
    //-----------------------------------------
    dma_transaction trans;

    //-----------------------------------------
    // Number of Transactions
    //-----------------------------------------
    int num_transactions;

    //-----------------------------------------
    // Constructor
    //-----------------------------------------
    function new(mailbox #(dma_transaction) gen2drv);

        this.gen2drv = gen2drv;
        num_transactions = 10;

    endfunction

    //-----------------------------------------
    // Run Task
    //-----------------------------------------
    task run();

        repeat(num_transactions) begin

            // Create Transaction
            trans = new();

            // Randomize
            if(!trans.randomize()) begin

                $display("[GENERATOR] Randomization Failed");
                $finish;

            end

            $display("\n[GENERATOR] Generated Transaction");

            trans.display();

            // Send Copy to Driver
            gen2drv.put(trans.copy());

            #20;

        end

        $display("\n========================================");
        $display(" Generator Completed");
        $display(" Total Transactions = %0d", num_transactions);
        $display("========================================");

    endtask

endclass