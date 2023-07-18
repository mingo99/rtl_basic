module rr_arb #(
    parameter       N = 8
)(
    input           clk,rst_n,
    input  [N-1:0]  init_pri,
    input  [N-1:0]  req,
    output [N-1:0]  gnt
);

reg [N-1:0] rr_pri; // One hot code
always @(posedge clk) begin
    if(~rst_n)    rr_pri <= init_pri;
    else if(|gnt) rr_pri <= {rr_pri[N-2:0],rr_pri[N-1]};
end

wire [N*2-1: 0] d_req         = {req,req};
wire [N*2-1: 0] d_req_sub_pri = d_req-rr_pri;
wire [N*2-1: 0] d_gnt         = d_req&(~d_req_sub_pri);
assign gnt = d_gnt[N*2-1:N]|d_gnt[N-1:0];

endmodule