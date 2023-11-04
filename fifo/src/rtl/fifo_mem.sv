module fifo_mem #(
    parameter int DWIDTH = 8,
    parameter int AWIDTH = 4
) (  // verilog_format: off
    input  wire              clk, wren,
    input  wire [AWIDTH-1:0] waddr, raddr,
    input  wire [DWIDTH-1:0] wdata,
    output wire [DWIDTH-1:0] rdata
); // verilog_format: on

   // RTL Verilog memory model
    localparam int DEPTH = 1 << AWIDTH;
    reg [DWIDTH-1:0] mem[DEPTH];
    assign rdata = mem[raddr];

    always @(posedge clk) begin
        if (wren) mem[waddr] <= wdata;
    end

endmodule

