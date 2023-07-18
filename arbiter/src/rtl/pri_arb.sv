module pri_arb #(
    parameter N = 3
) (
    input  [N-1:0] req,
    output [N-1:0] gnt
);

assign gnt = req & (~(req-1));

endmodule