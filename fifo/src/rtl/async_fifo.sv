module async_fifo #(
    parameter logic [31:0] DWIDTH = 8,
    parameter logic [31:0] AWIDTH = 4
) (
    input  wire              wclk,
    input  wire              rclk,
    input  wire              wrstn,
    input  wire              rrstn,
    input  wire              wren,
    input  wire              rden,
    input  wire [DWIDTH-1:0] din,
    output wire [DWIDTH-1:0] dout,
    output reg               full,
    output reg               empty
);
    reg [AWIDTH:0] wbin, wptr, rbin, rptr;
    wire [AWIDTH:0] wbin_nxt, wptr_nxt, rbin_nxt, rptr_nxt;

    // assign wbin_nxt = wbin + wren&(~full);
    // assign rbin_nxt = rbin + rden&(~empty);
    assign wbin_nxt = wren & (~full) ? wbin + 1'b1 : wbin;
    assign rbin_nxt = rden & (~empty) ? rbin + 1'b1 : rbin;
    assign wptr_nxt = (wbin_nxt >> 1) ^ wbin_nxt;
    assign rptr_nxt = (rbin_nxt >> 1) ^ rbin_nxt;

    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            {wbin, wptr} <= 'b0;
        end else begin
            {wbin, wptr} <= {wbin_nxt, wptr_nxt};
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            {rbin, rptr} <= 'b0;
        end else begin
            {rbin, rptr} <= {rbin_nxt, rptr_nxt};
        end
    end

    wire [AWIDTH-1:0] waddr = wbin[AWIDTH-1:0];
    wire [AWIDTH-1:0] raddr = rbin[AWIDTH-1:0];

    reg [AWIDTH:0] wq1_rptr, wq2_rptr;
    reg [AWIDTH:0] rq1_wptr, rq2_wptr;

    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            {wq2_rptr, wq1_rptr} <= 'b0;
        end else begin
            {wq2_rptr, wq1_rptr} <= {wq1_rptr, rptr};
        end
    end

    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            {rq2_wptr, rq1_wptr} <= 'b0;
        end else begin
            {rq2_wptr, rq1_wptr} <= {rq1_wptr, wptr};
        end
    end


    wire full_val = wptr_nxt == {~wq2_rptr[AWIDTH:AWIDTH-1], wq2_rptr[AWIDTH-2:0]};
    always @(posedge wclk or negedge wrstn) begin
        if (~wrstn) begin
            full <= 'b0;
        end else begin
            full <= full_val;
        end
    end

    wire empty_val = rptr_nxt == rq2_wptr;
    always @(posedge rclk or negedge rrstn) begin
        if (~rrstn) begin
            empty <= 'b0;
        end else begin
            empty <= empty_val;
        end
    end

    fifo_mem #(
        .DWIDTH(DWIDTH),
        .AWIDTH(AWIDTH)
    ) u_fifo_mem (
        .clk  (wclk),
        .wren (wren & (~full)),
        .waddr(waddr),
        .raddr(raddr),
        .wdata(din),
        .rdata(dout)
    );

endmodule
