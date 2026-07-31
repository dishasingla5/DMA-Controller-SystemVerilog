module ch_fsm (
    input  logic        clk,
    input  logic        rst_n,

    input  logic [31:0] src_addr,
    input  logic [31:0] dst_addr,
    input  logic [31:0] length,

    input  logic        enable,
    input  logic        start,

    output logic        ch_req,
    input  logic        ch_grant,

    output logic [31:0] fsm_src_addr,
    output logic [31:0] fsm_dst_addr,
    output logic [31:0] fsm_length,
    output logic        fsm_start,

    input  logic        fsm_done,

    output logic        busy,
    output logic        done
);

typedef enum logic [2:0] {
    IDLE,
    WAIT_GRANT,
    START_TRANSFER,
    WAIT_DONE,
    COMPLETE
} state_t;

state_t curr_state, next_state;


//-----------------------------------------------------
// State Register
//-----------------------------------------------------

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        curr_state <= IDLE;
    else
        curr_state <= next_state;
end


//-----------------------------------------------------
// Next State Logic
//-----------------------------------------------------

always_comb begin

    next_state = curr_state;

    case (curr_state)

        IDLE: begin
            if (enable && start)
                next_state = WAIT_GRANT;
        end

        WAIT_GRANT: begin
            if (ch_grant)
                next_state = START_TRANSFER;
        end

        START_TRANSFER: begin
            next_state = WAIT_DONE;
        end

        WAIT_DONE: begin
            if (fsm_done)
                next_state = COMPLETE;
        end

        COMPLETE: begin
            next_state = IDLE;
        end

        default: begin
            next_state = IDLE;
        end

    endcase

end


//-----------------------------------------------------
// Output Logic
//-----------------------------------------------------

always_comb begin

    ch_req       = 1'b0;
    busy         = 1'b0;
    done         = 1'b0;
    fsm_start    = 1'b0;

    fsm_src_addr = src_addr;
    fsm_dst_addr = dst_addr;
    fsm_length   = length;

    case (curr_state)

        IDLE: begin
        end

        WAIT_GRANT: begin
            ch_req = 1'b1;
            busy   = 1'b1;
        end

        START_TRANSFER: begin
            ch_req    = 1'b1;
            busy      = 1'b1;
            fsm_start = 1'b1;
        end

        // ******** FIX ********
        // Keep requesting until AXI finishes.
        // This allows the arbiter's sticky grant to
        // hold the channel for the entire transfer.
        WAIT_DONE: begin
            ch_req = 1'b1;
            busy   = 1'b1;
        end

        COMPLETE: begin
            done = 1'b1;
        end

    endcase

end

endmodule