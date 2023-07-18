module fifo_mem #(
    parameter DWIDTH = 8,
    parameter AWIDTH = 4
) (
    input  wire              wclk, wren,
    input  wire [AWIDTH-1:0] waddr, raddr,
    input  wire [DWIDTH-1:0] wdata,
    output wire [DWIDTH-1:0] rdata
);

`ifdef VENDORRAM 
    // instantiation of a vendor's dual-port RAM 
    vendor_ram mem(
        .dout       (rdata), 
        .din        (wdata), 
        .waddr      (waddr), 
        .raddr      (raddr), 
        .wclken     (wren), 
        .wclken_n   (!wren), 
        .clk        (wclk)
    ); 
`else 
    // RTL Verilog memory model 
    localparam DEPTH = 1<<AWIDTH; 
    reg [DWIDTH-1:0] mem [0:DEPTH-1]; 
    assign rdata = mem[raddr]; 

    always @(posedge wclk) begin
        if(wren) mem[waddr] <= wdata;
    end
`endif

endmodule