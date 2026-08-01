module axi4_lite_slave #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32
)(
    input logic clk,
    input logic rst_n,

    axil_if cfg_if,

    output logic [ADDR_WIDTH-1:0] wr_addr,
    output logic [DATA_WIDTH-1:0] wr_data,
    output logic                  wr_en,

    output logic [ADDR_WIDTH-1:0] rd_addr,
    output logic                  rd_en,

    input logic [DATA_WIDTH-1:0] rd_data
);

always_ff @(posedge clk or negedge rst_n) begin

    if(!rst_n) begin

        wr_en <= 0;
        rd_en <= 0;

        cfg_if.awready <= 0;
        cfg_if.wready  <= 0;
        cfg_if.bvalid  <= 0;
        cfg_if.bresp   <= 0;

        cfg_if.arready <= 0;
        cfg_if.rvalid  <= 0;
        cfg_if.rresp   <= 0;
        cfg_if.rdata   <= 0;

    end
    else begin

        wr_en <= 0;
        rd_en <= 0;

        cfg_if.awready <= 0;
        cfg_if.wready  <= 0;
        cfg_if.arready <= 0;

        //-----------------------------
        // Write
        //-----------------------------

        if(cfg_if.awvalid && cfg_if.wvalid && !cfg_if.bvalid) begin

            wr_addr <= cfg_if.awaddr;
            wr_data <= cfg_if.wdata;
            wr_en   <= 1;

            cfg_if.awready <= 1;
            cfg_if.wready  <= 1;
            cfg_if.bvalid  <= 1;
            cfg_if.bresp   <= 2'b00;

        end

        if(cfg_if.bvalid && cfg_if.bready)
            cfg_if.bvalid <= 0;

        //-----------------------------
        // Read
        //-----------------------------

        if(cfg_if.arvalid && !cfg_if.rvalid) begin

            rd_addr <= cfg_if.araddr;
            rd_en   <= 1;

            cfg_if.arready <= 1;
            cfg_if.rvalid  <= 1;
            cfg_if.rresp   <= 0;
            cfg_if.rdata   <= rd_data;

        end

        if(cfg_if.rvalid && cfg_if.rready)
            cfg_if.rvalid <= 0;

    end

end

endmodule