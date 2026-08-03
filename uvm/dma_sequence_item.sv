`ifndef DMA_SEQUENCE_ITEM_SV
`define DMA_SEQUENCE_ITEM_SV

`include "uvm_macros.svh"
import uvm_pkg::*;

class dma_sequence_item extends uvm_sequence_item;

    //------------------------------------------
    // Transaction Fields
    //------------------------------------------

    rand bit [1:0]  channel;
    rand bit [31:0] src_addr;
    rand bit [31:0] dst_addr;
    rand bit [31:0] length;

    rand bit        enable;
    rand bit        start;

    //------------------------------------------
    // Factory Registration + Field Automation
    //------------------------------------------

    `uvm_object_utils_begin(dma_sequence_item)
        `uvm_field_int(channel , UVM_ALL_ON)
        `uvm_field_int(src_addr, UVM_ALL_ON)
        `uvm_field_int(dst_addr, UVM_ALL_ON)
        `uvm_field_int(length  , UVM_ALL_ON)
        `uvm_field_int(enable  , UVM_ALL_ON)
        `uvm_field_int(start   , UVM_ALL_ON)
    `uvm_object_utils_end

    //------------------------------------------
    // Constructor
    //------------------------------------------

    function new(string name = "dma_sequence_item");
        super.new(name);

        enable = 1'b1;
        start  = 1'b1;
    endfunction

    //------------------------------------------
    // Constraints
    //------------------------------------------

    constraint ch_c {
        channel inside {[0:3]};
    }

    constraint src_c {
        src_addr inside {
            32'h000,
            32'h020,
            32'h040,
            32'h060
        };
    }

    constraint dst_c {
        dst_addr inside {
            32'h100,
            32'h120,
            32'h140,
            32'h160
        };
    }

    constraint len_c {
        length inside {[1:8]};
    }

    constraint addr_c {
        src_addr != dst_addr;
    }

    //------------------------------------------
    // Print
    //------------------------------------------

    function void do_print(uvm_printer printer);

        super.do_print(printer);

        printer.print_field_int("channel",  channel,  2,  UVM_DEC);
        printer.print_field_int("src_addr", src_addr, 32, UVM_HEX);
        printer.print_field_int("dst_addr", dst_addr, 32, UVM_HEX);
        printer.print_field_int("length",   length,   32, UVM_DEC);
        printer.print_field_int("enable",   enable,   1,  UVM_DEC);
        printer.print_field_int("start",    start,    1,  UVM_DEC);

    endfunction

    //------------------------------------------
    // Copy
    //------------------------------------------

    function void do_copy(uvm_object rhs);

        dma_sequence_item rhs_;

        if(!$cast(rhs_, rhs))
            `uvm_fatal("COPY", "Cast failed in do_copy()")

        super.do_copy(rhs);

        channel  = rhs_.channel;
        src_addr = rhs_.src_addr;
        dst_addr = rhs_.dst_addr;
        length   = rhs_.length;
        enable   = rhs_.enable;
        start    = rhs_.start;

    endfunction

    //------------------------------------------
    // Compare
    //------------------------------------------

    function bit do_compare(uvm_object rhs,
                            uvm_comparer comparer);

        dma_sequence_item rhs_;

        if(!$cast(rhs_, rhs))
            return 0;

        return super.do_compare(rhs, comparer);

    endfunction

endclass

`endif