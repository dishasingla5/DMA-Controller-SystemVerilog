class dma_transaction;

    //------------------------------------------
    // Transaction Fields
    //------------------------------------------

    rand bit [1:0] channel;

    rand bit [31:0] src_addr;
    rand bit [31:0] dst_addr;

    rand bit [31:0] length;

    bit enable;
    bit start;

    //------------------------------------------
    // Constructor
    //------------------------------------------

    function new();
        enable = 1'b1;
        start  = 1'b1;
    endfunction

    //------------------------------------------
    // Constraints
    //------------------------------------------

    // Four DMA channels
    constraint ch_c {
        channel inside {[0:3]};
    }

    // Valid source addresses used by memory model
    constraint src_c {
        src_addr inside {
            32'h000,
            32'h020,
            32'h040,
            32'h060
        };
    }

    // Valid destination addresses
    constraint dst_c {
        dst_addr inside {
            32'h100,
            32'h120,
            32'h140,
            32'h160
        };
    }

    // Transfer length (words)
    constraint len_c {
        length inside {[1:8]};
    }

    // Source and destination must differ
    constraint addr_c {
        src_addr != dst_addr;
    }

    //------------------------------------------
    // Copy Function
    //------------------------------------------

    function dma_transaction copy();

        dma_transaction tr;

        tr = new();

        tr.channel  = this.channel;
        tr.src_addr = this.src_addr;
        tr.dst_addr = this.dst_addr;
        tr.length   = this.length;
        tr.enable   = this.enable;
        tr.start    = this.start;

        return tr;

    endfunction

    //------------------------------------------
    // Display
    //------------------------------------------

    function void display();

        $display("----------------------------------------");
        $display("DMA Transaction");
        $display("----------------------------------------");
        $display("Channel      : %0d", channel);
        $display("Source Addr  : 0x%03h", src_addr);
        $display("Dest Addr    : 0x%03h", dst_addr);
        $display("Length       : %0d", length);
        $display("Enable       : %0d", enable);
        $display("Start        : %0d", start);
        $display("----------------------------------------");

    endfunction

endclass