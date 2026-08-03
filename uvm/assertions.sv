module dma_assertions (

    input logic       clk,
    input logic       rst_n,

    input logic [3:0] ch_req,
    input logic [3:0] ch_grant,
    input logic [3:0] busy,
    input logic [3:0] done

);

    //----------------------------------------
    // One-Hot Grant
    //----------------------------------------

    property p_one_hot_grant;
        @(posedge clk)
        disable iff (!rst_n)
        $onehot0(ch_grant);
    endproperty

    A_ONE_HOT_GRANT :
        assert property(p_one_hot_grant)
        else
            $error("[ASSERT] Multiple DMA grants detected");

    //----------------------------------------
    // Grant Requires Request
    //----------------------------------------

    property p_grant_requires_request;
        @(posedge clk)
        disable iff (!rst_n)
        (ch_grant != 0) |-> (ch_req != 0);
    endproperty

    A_GRANT_REQ :
        assert property(p_grant_requires_request)
        else
            $error("[ASSERT] Grant asserted without request");

    //----------------------------------------
    // Busy after Grant
    //----------------------------------------

    property p_busy_after_grant;
        @(posedge clk)
        disable iff (!rst_n)
        (ch_grant != 0) |=> (busy != 0);
    endproperty

    A_BUSY :
        assert property(p_busy_after_grant)
        else
            $error("[ASSERT] Busy not asserted after grant");

    //----------------------------------------
    // Done only when Busy
    //----------------------------------------

    property p_done_when_busy;
        @(posedge clk)
        disable iff (!rst_n)
        (done != 0) |-> (busy != 0);
    endproperty

    A_DONE :
        assert property(p_done_when_busy)
        else
            $error("[ASSERT] Done asserted without busy");

endmodule