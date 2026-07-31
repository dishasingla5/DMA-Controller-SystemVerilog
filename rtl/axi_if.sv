interface axi_if #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
);

    //----------------------------------
    // Read Address Channel
    //----------------------------------

    logic [ADDR_WIDTH-1:0] araddr;
    logic                  arvalid;
    logic                  arready;
    logic [7:0]            arlen;

    //----------------------------------
    // Read Data Channel
    //----------------------------------

    logic [DATA_WIDTH-1:0] rdata;
    logic                  rvalid;
    logic                  rready;
    logic                  rlast;

    //----------------------------------
    // Write Address Channel
    //----------------------------------

    logic [ADDR_WIDTH-1:0] awaddr;
    logic                  awvalid;
    logic                  awready;
    logic [7:0]            awlen;

    //----------------------------------
    // Write Data Channel
    //----------------------------------

    logic [DATA_WIDTH-1:0] wdata;
    logic                  wvalid;
    logic                  wready;
    logic                  wlast;

    //----------------------------------
    // Write Response Channel
    //----------------------------------

    logic                  bvalid;
    logic                  bready;

endinterface