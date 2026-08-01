
class dma_test;

    //-----------------------------------------
    // Environment
    //-----------------------------------------

    dma_environment env;


    //-----------------------------------------
    // Virtual Interface
    //-----------------------------------------

    virtual axil_if cfg_if;


    //-----------------------------------------
    // Constructor
    //-----------------------------------------

    function new(
        virtual axil_if cfg_if
    );

        this.cfg_if = cfg_if;

    endfunction



    //-----------------------------------------
    // Run Test
    //-----------------------------------------

    task run();


        $display("");
        $display("======================================");
        $display("          DMA TEST START");
        $display("======================================");


        //---------------------------------
        // Create Environment
        //---------------------------------

        env = new(cfg_if);



        //---------------------------------
        // Start Environment
        //---------------------------------

        fork

            env.run();

        join_none



        //---------------------------------
        // Wait for Scoreboard Completion
        //---------------------------------

        wait(env.scb.total == env.scb.expected_transactions);



        //---------------------------------
        // Final Delay
        //---------------------------------

        #50;


        $display("");
        $display("======================================");
        $display("          DMA TEST COMPLETE");
        $display("======================================");


        if(env.scb.fail == 0) begin

            $display("STATUS : PASSED");

        end

        else begin

            $display("STATUS : FAILED");

        end


        $display("======================================");


        //---------------------------------
        // End Simulation
        //---------------------------------

        $finish;


    endtask


endclass